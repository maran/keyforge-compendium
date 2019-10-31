class AddHouseIdToCards < ActiveRecord::Migration[5.2]
  def change
    add_reference :cards, :house, foreign_key: true
    Card.find_each do |c|
      h= House.find_by(name: c.house)
      c.update_attribute(:house_id, h.id)
    end
  end
end
