class CreateDecksUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :decks_users do |t|
      t.belongs_to :user, foreign_key: true
      t.belongs_to :deck, foreign_key: true

      t.timestamps
    end
  end
end
