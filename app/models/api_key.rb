class ApiKey < ApplicationRecord
  belongs_to :user
  before_create :set_secrets

  validates_presence_of :name

  def set_secrets
    self.key = SecureRandom.hex(20)
    self.secret = SecureRandom.hex(40)
  end
end
