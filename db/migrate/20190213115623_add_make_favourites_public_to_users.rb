class AddMakeFavouritesPublicToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :favourites_public, :boolean, default: false
  end
end
