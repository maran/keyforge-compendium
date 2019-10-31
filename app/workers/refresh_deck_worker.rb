class RefreshDeckWorker
  include Sidekiq::Worker

  def perform(uuid)
    ImportDeckService.refresh(uuid)
  end
end
