class CreateDecksHousesTable < ActiveRecord::Migration[5.2]
  def change
    create_table :decks_houses do |t|
      t.integer :deck_id
      t.integer :house_id
    end
  end
end
