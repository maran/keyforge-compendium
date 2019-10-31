class CreateConversations < ActiveRecord::Migration[5.2]
  def change
    create_table :conversations do |t|
      t.text :subject
      t.belongs_to :user, foreign_key: true
      t.belongs_to :receiving_user,  foreign_key: {to_table: :users}
      t.belongs_to :deck

      t.timestamps
    end
  end
end
