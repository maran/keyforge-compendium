class Category < ApplicationRecord
  belongs_to :user
  has_many :decks_users, dependent: :nullify

  validates :name, presence: true
end
