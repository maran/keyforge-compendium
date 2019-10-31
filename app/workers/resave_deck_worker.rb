class ResaveDeckWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'lazy'

  def perform(id)
    Deck.find(id).save
  end
end
