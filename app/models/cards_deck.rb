class CardsDeck < ActiveRecord::Base
  belongs_to :card
  belongs_to :deck
  delegate :tags, :power, :amber, :front_image, :armor, :title, :house, to: :card

  scope :with_card_ids, -> (ids) { where(card_id: ids) }
#  after_save :update_counter_cache
#  after_destroy :update_counter_cache

  def after_destroy
    self.update_counter_cache
  end

  def update_counter_cache
    self.card.cards_decks_count = self.card.decks.distinct.count
    self.card.save
  end
end
