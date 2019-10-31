class AddEffiencyWeightsToCards < ActiveRecord::Migration[5.2]
  def change
    add_column :cards, :board_efficiency_weight, :decimal, scale: 2, precision: 6
    add_column :cards, :card_efficiency_weight, :decimal, scale: 2, precision: 6
    add_column :cards, :hate_efficiency_weight, :decimal, scale: 2, precision: 6
  end
end
