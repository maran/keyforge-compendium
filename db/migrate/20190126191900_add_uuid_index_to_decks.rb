class AddUuidIndexToDecks < ActiveRecord::Migration[5.2]
  def change
    add_index :decks, :uuid
  end
end
