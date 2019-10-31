class AddCardHashIndexToDecks < ActiveRecord::Migration[5.2]
  def change
     add_index :decks, :card_hash
  end
end
