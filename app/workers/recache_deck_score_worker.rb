class RecacheDeckScoreWorker
  include Sidekiq::Worker

  def perform()
    Setting.save_std
    Setting.save_avg

    Deck.select("id").find_each do |d|
      ResaveDeckWorker.perform_async(d.id)
    end
  end
end
