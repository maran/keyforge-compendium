class ImportVirtualDeckService
  def self.run(virtual_deck)
    deck = Deck.new
    deck.name = virtual_deck.deck_name
    deck.uuid = "VIRTUAL-#{SecureRandom.uuid}"
    deck.house_ids = virtual_deck.cards.keys
    deck.sas_rating = 0
    deck.save
    cards = virtual_deck.all_cards
    cards.each do |c|
      next if deck.cards_decks.where(card_id: c).any?
      # We do this so we don't import double cards
      card = deck.cards_decks.build
      card.count = cards.count(c)
      card.card_id = c
      card.save
    end
    deck.save && virtual_deck.update_attribute(:deck_id, deck.id)

    virtual_deck.user.decks << deck
  end
end
