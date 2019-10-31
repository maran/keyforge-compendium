require 'net/http'
class ImportDeckWorker
  include Sidekiq::Worker

  def perform(page, page_size)
    setting = Setting.find_by(name: "scraping_deck_page")
    setting.with_lock do
      setting.update_attribute(:value, page)
    end

    grab = "https://www.keyforgegame.com/api/decks/?page=#{page}&page_size=#{page_size}&ordering=date&links=cards"
    puts "Grabbing: #{grab}"
    decks = Net::HTTP.get(URI(grab))
    p = JSON.parse(decks)
    if p.has_key?("data")
      p["data"].each do |d|
        deck = Deck.find_or_initialize_by(uuid: d["id"])
        deck.with_lock do
          if deck.new_record?
            ImportDeckService.update_deck_from_card_and_links(deck,d,p["_linked"])
            deck.save # ensure fresh cache stats
          end
        end
      end
    end
  end
end
