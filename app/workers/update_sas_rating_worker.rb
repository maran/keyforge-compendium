class UpdateSasRatingWorker
  include Sidekiq::Worker

  def perform(offset, limit = 100)
    Deck.where("uuid NOT ILIKE ?", "VIRTUAL%").order(created_at: :desc).where(sas_rating: nil).offset(offset).limit(limit).find_each do |d|
      unless d.sas_rating.present?
        d.update_sas_rating
      end
    end
  end
end
