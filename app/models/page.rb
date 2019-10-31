class Page < ApplicationRecord
  include Slugable

  validates :title, presence: true
  validates :content, presence: true
end
