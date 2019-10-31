class CreateSources < ActiveRecord::Migration[5.2]
  def change
    create_table :sources do |t|
      t.string :name
      t.string :url

      t.timestamps
    end
    change_table :faqs do |t|
      t.belongs_to :rule
      t.belongs_to :source
    end
  end
end
