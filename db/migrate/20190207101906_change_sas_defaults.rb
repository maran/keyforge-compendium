class ChangeSasDefaults < ActiveRecord::Migration[5.2]
  def change
    change_column :decks, :sas_rating, :integer, :default => 0
    change_column :decks, :cards_rating, :integer, :default => 0
    change_column :decks, :synergy_rating, :integer, :default => 0
    change_column :decks, :anti_synergy_rating, :integer, :default => 0
  end
end
