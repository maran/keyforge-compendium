class DecksUser < ApplicationRecord
  REASON_SALE = 2

  belongs_to :user
  belongs_to :deck
  belongs_to :category, optional: true

  accepts_nested_attributes_for :category
  validates :deck_id, uniqueness: { scope: :user_id}

  delegate :name, :uuid, to: :deck

  scope :ids_for_sale, -> { select(:deck_id).where(reason: REASON_SALE) }
  scope :for_sale, -> { where(reason: REASON_SALE) }

  def win_rate_against(other_deck_id)
    total_games = self.user.games.with_decks(deck_id, other_deck_id).count
    wins = self.user.games.with_decks(deck_id, other_deck_id).with_winning_deck(deck_id).count
    if wins > 0
      return ((100 * wins) / total_games).round(2)
    else
      return 0
    end
  end

  def self.reasons
    [
      ["",0],
      ["I own this deck",1],
      ["I own this deck and it's for sale/trade",2],
      ["I want this deck",3],
    ]
  end
end
