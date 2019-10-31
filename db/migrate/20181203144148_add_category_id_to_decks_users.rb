class AddCategoryIdToDecksUsers < ActiveRecord::Migration[5.2]
  def change
    add_reference :decks_users, :category, foreign_key: true, on_delete: :cascade
  end
end
