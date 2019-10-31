class Setting < ApplicationRecord
  def self.save_avg
    ['a','b','c','e'].each do |x|
      avg = Deck.where.not("a_rating = 0").average("#{x}_rating").round(2)
      setting = Setting.find_or_initialize_by(name: "avg_#{x}_rating")
      setting.value = avg
      setting.save
    end
  end

  def self.save_std
    ['a','b','c','e'].each do |x|
      std = Deck.select("stddev(#{x}_rating) as std").reorder('').first.std
      setting = Setting.find_or_initialize_by(name: "std_#{x}_rating")
      setting.value = std
      setting.save
    end
  end
end
