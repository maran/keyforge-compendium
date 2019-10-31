class AddParentIdToCards < ActiveRecord::Migration[5.2]
  def change
    add_column :cards, :parent_id, :bigint
  end
end
