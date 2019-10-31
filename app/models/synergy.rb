class Synergy < ApplicationRecord
  belongs_to :card
  belongs_to :synergy_card, class_name: "Card", foreign_key: "synergy_card_id"
  belongs_to :synergy_reason

  scope :with_cards, ->(ids) { where(synergy_card_id: ids) }
  default_scope -> { order(weight: :desc) }

  def rating_for_deck(deck)
    (self.weight * deck.cards_decks.find_by(card_id: self.synergy_card_id).count).round(4)
  end
end
