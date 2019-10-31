class AddDeckIndexToCardsDecks < ActiveRecord::Migration[5.2]
  def change
    add_index :cards_decks, :deck_id
  end
end
