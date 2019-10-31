class CreateVirtualDecks < ActiveRecord::Migration[5.2]
  def change
    create_table :virtual_decks do |t|
      t.belongs_to :user, foreign_key: true
      t.belongs_to :deck
      t.text :raw_text
      t.string :deck_name
      t.text :cards
      t.boolean :ready_for_import, default: false

      t.timestamps
    end
  end
end
