class Tag < ApplicationRecord
  has_and_belongs_to_many :cards

  attr_accessor :virtual_cards, :virtual_count
end
