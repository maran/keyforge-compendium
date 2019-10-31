class AddIndexToCardsDecksOnCardAndCount < ActiveRecord::Migration[5.2]
  def change
    add_index :cards_decks, [:card_id, :count]
  end
end
