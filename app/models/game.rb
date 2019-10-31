class Game < ApplicationRecord
  belongs_to :user
  belongs_to :losing_player, class_name: "User", foreign_key: "losing_player_id", optional: true
  belongs_to :winning_player, class_name: "User", foreign_key: "winning_player_id", optional: true

  belongs_to :winning_deck, class_name: "Deck", foreign_key: "winning_deck_id"
  belongs_to :losing_deck, class_name: "Deck", foreign_key: "losing_deck_id"

  validates :winning_deck_id, presence: true
  validates :losing_deck_id, presence: true
  validates :played_at, presence: true

  validate :cant_play_yourself

  scope :with_decks, -> (deck_id, other_deck_id) { where("( (losing_deck_id = ? AND winning_deck_id = ?) OR (losing_deck_id = ? AND winning_deck_id = ?)) ", deck_id, other_deck_id, other_deck_id, deck_id) }
  scope :with_deck, -> (deck_id) { where("losing_deck_id = ? OR winning_deck_id = ?", deck_id, deck_id) }
  scope :with_winning_deck, -> (deck_id) { where("winning_deck_id = ?", deck_id) }
  default_scope -> { order(played_at: :desc) }

  def cant_play_yourself
    errors.add(:winning_deck_id, "can't play against itself silly.") if self.winning_deck_id == self.losing_deck_id
  end

  def self.unique_decks
    Deck.find(order(created_at: :desc).collect{|x| [x["winning_deck_id"], x["losing_deck_id"]]}.flatten.uniq)
  end
end
