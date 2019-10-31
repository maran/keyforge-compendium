class AddIsBlogToPages < ActiveRecord::Migration[5.2]
  def change
    add_column :pages, :is_blog, :boolean, default: false
  end
end
