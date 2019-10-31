class CreateGames < ActiveRecord::Migration[5.2]
  def change
    create_table :games do |t|
      t.belongs_to :user, foreign_key: true
      t.belongs_to :winning_deck, foreign_key: {to_table: :decks}
      t.belongs_to :losing_deck, foreign_key: {to_table: :decks}

      t.belongs_to :winning_player, foreign_key: {to_table: :users}
      t.belongs_to :losing_player, foreign_key: {to_table: :users}

      t.string :winning_player_email
      t.string :losing_player_email


      t.datetime :played_at

      t.timestamps
    end
  end
end
