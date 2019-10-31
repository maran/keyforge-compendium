class CreateRules < ActiveRecord::Migration[5.2]
  def change
    create_table :rules do |t|
      t.string :title
      t.text :content
      t.string :slug
      t.integer :position

      t.timestamps
    end
  end
end
