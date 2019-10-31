class AddSanitizedNameToDecks < ActiveRecord::Migration[5.2]
  def change
    add_column :decks, :sanitized_name, :string, index: true
  end
end
