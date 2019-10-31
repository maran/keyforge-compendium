class MakeIsMaverickFalseByDefault < ActiveRecord::Migration[5.2]
  def up
    change_column :cards, :is_maverick, :boolean, default: false
    change_column :cards, :cards_decks_count, :integer, default: 0
  end
  def down
  end
end
