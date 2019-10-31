class House < ApplicationRecord
  has_and_belongs_to_many :decks
end
