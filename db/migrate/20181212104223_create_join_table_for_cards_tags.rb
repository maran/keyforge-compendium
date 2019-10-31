class CreateJoinTableForCardsTags < ActiveRecord::Migration[5.2]
  def change
    create_join_table :cards, :tags
  end
end
