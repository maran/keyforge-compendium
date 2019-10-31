class RenameRuleIdToRuleSourceId < ActiveRecord::Migration[5.2]
  def change
    rename_column :faqs, :rule_id, :rule_source_id
  end
end
