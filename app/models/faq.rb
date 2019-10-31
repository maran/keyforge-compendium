class Faq < ApplicationRecord
  belongs_to :card, optional: true
  belongs_to :rule, optional: true

  # Sources
  belongs_to :rule_source, optional: true, foreign_key: :rule_source_id, class_name: "Rule"
  belongs_to :source, optional: true
end
