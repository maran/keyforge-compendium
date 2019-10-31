class AddArtistToCards < ActiveRecord::Migration[5.2]
  def change
    add_column :cards, :artist, :string
  end
end
