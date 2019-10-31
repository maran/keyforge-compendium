class AddHouseIdIndexToDecksHouses < ActiveRecord::Migration[5.2]
  def change
    add_index :decks_houses, :house_id
    add_index :decks_houses, :deck_id
  end
end
