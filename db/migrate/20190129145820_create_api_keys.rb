class CreateApiKeys < ActiveRecord::Migration[5.2]
  def change
    create_table :api_keys do |t|
      t.string :key
      t.string :secret
      t.string :name
      t.integer :requests, default: 0
      t.boolean :active, default: true
      t.belongs_to :user, foreign_key: true

      t.timestamps
    end
  end
end
