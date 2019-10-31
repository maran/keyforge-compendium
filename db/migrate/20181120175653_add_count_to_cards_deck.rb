class AddCountToCardsDeck < ActiveRecord::Migration[5.2]
  def change
    add_column :cards_decks, :count, :integer
  end
end
