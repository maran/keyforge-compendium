class CreateCards < ActiveRecord::Migration[5.2]
  def change
    create_table :cards do |t|
      t.string :uuid
      t.string :title
      t.string :house
      t.string :card_type
      t.string :front_image
      t.string :text
      t.string :traits
      t.integer :amber
      t.integer :power
      t.integer :armor
      t.string :rarity
      t.string :flavor_text
      t.integer :number
      t.boolean :is_maverick

      t.timestamps
    end
  end
end
