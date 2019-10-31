class AddVariousCachesToDecks < ActiveRecord::Migration[5.2]
  def change
    add_column :decks, :creature_count, :integer
    add_column :decks, :action_count, :integer
    add_column :decks, :artifact_count, :integer
    add_column :decks, :upgrade_count, :integer
    add_column :decks, :uncommon_count, :integer
    add_column :decks, :common_count, :integer
    add_column :decks, :rare_count, :integer
    add_column :decks, :fixed_count, :integer
    add_column :decks, :variant_count, :integer

    add_column :decks, :maverick_count, :integer
  end
end
