class AddReasonToDecksUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :decks_users, :reason, :integer, default: 0
  end
end
