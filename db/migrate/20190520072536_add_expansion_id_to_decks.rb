class AddExpansionIdToDecks < ActiveRecord::Migration[5.2]
  def change
    add_reference :decks, :expansion, foreign_key: true
  end
end
