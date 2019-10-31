class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable

  has_many :decks_users
  has_many :decks, through: :decks_users
  has_many :games
  has_many :categories
  has_many :conversations
  has_many :messages
  has_many :virtual_decks
  has_many :api_keys

  before_save :sanitized_name

  validates :username, uniqueness: true, if: -> (user) { user.username.present? }, length: { in: 3..20}, format: { with: /\A[a-zA-Z0-9]+\z/,
    message: "only allows alphanumerical" }

  def sanitized_name
    if self.username.present?
      self.username.downcase!
    end
  end

  def games_played_with_deck(deck_id)
    self.games.with_deck(deck_id).count
  end

  def win_rate(deck_id)
    total_games = self.games.with_deck(deck_id).count
    wins = self.games.with_winning_deck(deck_id).count
    if wins > 0
      return ((100 * wins) / total_games).round(2)
    else
      return 0
    end
  end

  def name
    return self.username if self.username.present?
    return self.email
  end
end
