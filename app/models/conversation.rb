class Conversation < ApplicationRecord
  belongs_to :user
  belongs_to :receiving_user, class_name: "User", foreign_key: "receiving_user_id"
  belongs_to :deck
  has_many :messages, dependent: :destroy

  accepts_nested_attributes_for :messages

  scope :with_user, -> (user_id) { where("receiving_user_id = ? or user_id = ?", user_id,user_id) }
end
