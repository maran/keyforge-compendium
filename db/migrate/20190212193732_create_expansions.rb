class CreateExpansions < ActiveRecord::Migration[5.2]
  def change
    create_table :expansions do |t|
      t.string :name
      t.string :abbr
      t.integer :official_id

      t.timestamps
    end

    cota = Expansion.create(name: "Call of the Archons", abbr: "CotA", official_id: 341)
    Expansion.create(name: "Age of Ascension", abbr: "AoA", official_id: 342)

    add_column :cards, :expansion_id, :bigint

    Card.update_all(expansion_id: cota.id)
  end
end
