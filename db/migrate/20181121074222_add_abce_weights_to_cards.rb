class AddAbceWeightsToCards < ActiveRecord::Migration[5.2]
  def change
   add_column :cards, :a_weight, :float, scale: 6, precision: 10
   add_column :cards, :b_weight, :float, scale: 6, precision: 10
   add_column :cards, :c_weight, :float, scale: 6, precision: 10
   add_column :cards, :e_weight, :float, scale: 6, precision: 10
  end
end
