class AddConsistencyRatingToDecks < ActiveRecord::Migration[5.2]
  def change
    add_column :decks, :consistency_rating, :decimal, scale: 6, precision: 10
  end
end
