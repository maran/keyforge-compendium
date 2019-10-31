require 'net/http'
namespace :import do
  task add_missing_sas: :environment do
    decks_per_worker = 100
    total = Deck.where("uuid NOT ILIKE ?", "VIRTUAL%").order(created_at: :desc).where(sas_rating: nil).count
    group_amount = total / decks_per_worker
    puts "Add missing SAS to #{total} decks. Doing #{decks_per_worker} decks per working. Creating #{group_amount} worker jobs"
    group_amount.times do |i|
      offset = i * decks_per_worker
      puts "Creating working for decks with offset #{offset}"
      UpdateSasRatingWorker.perform_async(offset, decks_per_worker)
    end
  end

  task win_rate: :environment do
    total = Game.count
    attributes = {consistency_rating: 0, sas_rating: 0, a_rating: 0, b_rating: 0, c_rating: 0, e_rating: 0, creature_count: 0, action_count: 0, artifact_count: 0, upgrade_count: 0, uncommon_count: 0, common_count: 0,rare_count: 0, fixed_count: 0,variant_count: 0, cards_rating: 0, synergy_rating: 0}

    Game.includes(:winning_deck).includes(:losing_deck).find_each do |g|
      attributes.keys.each do |k|
        if g.winning_deck.send(k).to_f >= g.losing_deck.send(k).to_f
          attributes[k] += 1
        end
      end
    end
    puts total
    attributes.sort_by{|k,v| v}.reverse.each do |k|
      puts "Results for #{k[0]}"
      puts "Percentage: #{((100.0 * k[1]) / total).round(4)}"
    end
  end

  task win_rate_a: :environment do
    total = Game.count
    win = {}
    options = [0.1,0.5,1,1.5,2,3,4,5]
    options.each do |i|
      Game.includes(:winning_deck).includes(:losing_deck).find_each do |g|
        if g.winning_deck.a_rating.to_f > (g.losing_deck.a_rating.to_f + i)
          win[i] ||= 0
          win[i] += 1
        end
      end
    end
    puts total
    win.sort_by{|k,v| v}.reverse.each do |k|
      puts "Results for difference in A-rating of: #{k[0]}"
      puts "Percentage: #{((100.0 * k[1]) / total).round(4)}"
      puts
    end
  end

  task artist: :environment do
    (1..370).each do |n|
      rcard= Net::HTTP.get(URI("http://api.libraryaccess.net:7001/cards/COTA/#{n}"))
      card = JSON.parse(rcard)
      Card.no_mavericks.find_by(number: n).update_attribute(:artist, card["artist"])
      sleep 1
    end
  end

  task sheet_import: :environment do
    require 'csv'
    i = 0
    CSV.foreach("cards.csv") do |row|
      i+=1
      next if i ==1
      puts "Card.find_by(number: #{row[0]}).update_attributes(a_weight: #{row[5]}, b_weight: #{row[6]}, c_weight: #{row[7]}, e_weight: #{row[8]})"
    end

  end

  task decks: :environment do
    decks = Net::HTTP.get(URI("https://www.keyforgegame.com/api/decks/"))
    max_decks = JSON.parse(decks)["count"].to_i
    page_size = 25
    start_page= 1
    setting = Setting.find_or_initialize_by(name: "scraping_deck_page")
    if setting.new_record?
      setting.value = start_page
      setting.save
    end

    start_page= setting.value.to_i
    end_page = (max_decks / page_size)
    puts "Importing decks from page #{start_page} to #{end_page} a page size of #{page_size} doing #{end_page-start_page} pages"
    (start_page..end_page).each do |page|
      ImportDeckWorker.perform_async(page, page_size)
    end
  end

  task cards: :environment do
    (1..5).each do |page|
      decks = Net::HTTP.get(URI("https://www.keyforgegame.com/api/decks/?page=#{page}&page_size=100&search=&power_level=0,11&chains=0,24&ordering=-date"))
      JSON.parse(decks)["data"].each do |deck|
        url = URI("https://www.keyforgegame.com/api/decks/#{deck['id']}/?links=cards")
        response = Net::HTTP.get(url)
        p = JSON.parse(response)
        p['_linked']['cards'].each do |c|
          unless c['is_maverick'] == true
            card = Card.find_or_initialize_by(number: c['card_number'])
            card.attributes = c
            card.uuid = c['id']
            card.save
          else
            puts "Skipping maverik card: #{c}"
          end
        end
      end
    end
  end
end

