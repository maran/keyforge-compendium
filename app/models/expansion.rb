class Expansion < ApplicationRecord
  has_many :cards
  has_many :decks

  def slug
    "#{self.id}-#{self.abbr}".parameterize
  end
end
