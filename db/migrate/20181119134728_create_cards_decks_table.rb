class CreateCardsDecksTable < ActiveRecord::Migration[5.2]
  def change
    create_table :cards_decks do |t|
      t.integer :deck_id
      t.integer :card_id
    end
  end
end
