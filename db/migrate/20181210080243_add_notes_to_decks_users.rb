class AddNotesToDecksUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :decks_users, :notes, :text
  end
end
