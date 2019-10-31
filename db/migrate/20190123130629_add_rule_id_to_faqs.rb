class AddRuleIdToFaqs < ActiveRecord::Migration[5.2]
  def change
    add_reference :faqs, :rule, foreign_key: true
  end
end
