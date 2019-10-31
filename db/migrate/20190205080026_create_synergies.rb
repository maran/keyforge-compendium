class CreateSynergies < ActiveRecord::Migration[5.2]
  def change
    add_column :cards, :base_score, :float, default: 1

    create_table :synergy_reasons do |t|
      t.string :name
      t.timestamps
    end

    create_table :synergies do |t|
      t.references :synergy_card
      t.belongs_to :card, foreign_key: true
      t.float :weight
      t.belongs_to :synergy_reason, foreign_key: true

      t.timestamps
    end
  end
end
