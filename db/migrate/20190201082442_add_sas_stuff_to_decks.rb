class AddSasStuffToDecks < ActiveRecord::Migration[5.2]
  def change
    add_column :decks, :sas_rating, :integer
    add_column :decks, :cards_rating, :integer
    add_column :decks, :synergy_rating, :integer
    add_column :decks, :anti_synergy_rating, :integer
    add_index :decks, :sas_rating
  end
end
