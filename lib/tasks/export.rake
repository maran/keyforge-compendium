namespace :export do
  task games: :environment do
    def build_result(winning_deck, losing_deck)
        items = [
          [winning_deck.uuid,losing_deck.uuid].shuffle, 0,

                winning_deck.sas_rating,losing_deck.sas_rating,

                winning_deck.consistency_rating,losing_deck.consistency_rating,

                winning_deck.creature_count,losing_deck.creature_count
        ].flatten
        items[2] = (items[0] ==winning_deck.uuid)? 0 : 1
        return items
    end

    puts "Total games:" + Game.count.to_s

    CSV.open(Rails.root + "./storage/games.csv", "wb") do |csv|
      csv << ["deck_one", "deck_two", "winner","Winning SAS", "Losing SAS", "Winning ADHD", "Losing ADHD", "Winning Creature", "Losing Creature"]
      Game.includes(:winning_deck).includes(:losing_deck).each do |game|
        if game.winning_deck.sas_rating == nil ||  game.losing_deck.sas_rating == nil
          puts game.id
          puts "Missing SAS"
          next
        end


        csv << build_result(game.winning_deck, game.losing_deck)
      end
    end

    CSV.open(Rails.root + "./storage/dunno.csv", "wb") do |csv|
      csv << ["deck_one", "deck_two", "winner","Winning SAS", "Losing SAS", "Winning ADHD", "Losing ADHD", "Winning Creature", "Losing Creature"]
      10.times do
        deck_one = Deck.limit(1).order((Arel.sql"RANDOM()")).first
        deck_two = Deck.limit(1).order((Arel.sql"RANDOM()")).first
        csv << build_result(deck_one, deck_two)
      end
    end
  end
end
