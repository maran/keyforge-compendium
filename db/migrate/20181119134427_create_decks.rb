class CreateDecks < ActiveRecord::Migration[5.2]
  def change
    create_table :decks do |t|
      t.string :name
      t.string :uuid
      t.integer :power_level
      t.integer :chains
      t.integer :wins
      t.integer :losses

      t.timestamps
    end
  end
end
