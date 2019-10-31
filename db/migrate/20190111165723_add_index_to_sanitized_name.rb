class AddIndexToSanitizedName < ActiveRecord::Migration[5.2]
  def change
    add_index :decks, :sanitized_name, opclass: :gin_trgm_ops, using: :gin
  end
end
