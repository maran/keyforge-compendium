class AddNameIndexToDecks < ActiveRecord::Migration[5.2]
  def change
     add_index :decks, :name
  end
end
