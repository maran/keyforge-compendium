class AddAbceCacheToDecks < ActiveRecord::Migration[5.2]
  def change
   add_column :decks, :a_rating, :float, scale: 2, precision: 6
   add_column :decks, :b_rating, :float, scale: 2, precision: 6
   add_column :decks, :c_rating, :float, scale: 2, precision: 6
   add_column :decks, :e_rating, :float, scale: 2, precision: 6
  end
end
