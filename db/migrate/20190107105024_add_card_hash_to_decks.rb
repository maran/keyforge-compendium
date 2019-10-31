class AddCardHashToDecks < ActiveRecord::Migration[5.2]
  def change
    add_column :decks, :card_hash, :string, index: true
  end
end
