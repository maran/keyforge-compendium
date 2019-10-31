class CreateFaqs < ActiveRecord::Migration[5.2]
  def change
    create_table :faqs do |t|
      t.text :question
      t.text :answer
      t.belongs_to :card, foreign_key: true

      t.timestamps
    end
  end
end
