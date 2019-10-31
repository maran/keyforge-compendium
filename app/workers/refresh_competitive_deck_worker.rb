require 'net/http'
class RefreshCompetitiveDeckWorker
  include Sidekiq::Worker

  def perform(page, page_size = 20)
    grab = "https://www.keyforgegame.com/api/decks/?page=#{page}&page_size=#{page_size}&ordering=date&links=cards&wins=1,100"
    puts "Grabbing: #{grab}"
    decks = Net::HTTP.get(URI(grab))
    p = JSON.parse(decks)
    p["data"].each do |d|
      deck = Deck.find_or_initialize_by(uuid: d["id"])
      deck.with_lock do
        ImportDeckService.update_deck_from_card_and_links(deck,d,p["_linked"])
      end
      deck.save # ensure fresh cache stats
    end
  end
end
