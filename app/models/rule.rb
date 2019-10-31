class Rule < ApplicationRecord
  include Slugable
  acts_as_list

  has_many :faqs
end
