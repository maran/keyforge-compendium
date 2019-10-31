class AddDecksCountToCardsDecks < ActiveRecord::Migration[5.2]
  def change
    add_column :cards, :cards_decks_count, :integer
  end
end
