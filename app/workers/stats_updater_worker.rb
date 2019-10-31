require 'net/http'

class StatsUpdaterWorker
  include Sidekiq::Worker

  def perform()
    Card.where(is_maverick: false).find_each do |card|
      card.update_counter_cache
      card.save
    end
  end
end
