class VirtualDeck < ApplicationRecord
  attr_accessor :card_ids

  has_one_attached :image, dependent: :destroy

  belongs_to :user
  belongs_to :deck, optional: true

  before_save :check_used_houses
  before_create :set_deck_name

  serialize :cards, Hash

  scope :can_be_imported, -> { where(ready_for_import: true).where(deck_id: nil) }


  def all_cards
    self.cards.collect{|x| x[1]}.flatten.reject(&:blank?)
  end

  def added?
    self.deck_id.present?
  end

  def has_similar_name?
    Deck.with_deck_name(self.deck_name).count > 0
  end

  def all_cards_present?
    self.all_cards.length == 36
  end

  def set_deck_name
    split = self.raw_text.split("DECK")
    if split.length > 1
      self.deck_name = split[0].gsub("\n","")
    end
  end

  def check_used_houses
    self.cards.each do |k,v|
      unless self.cards[k].reject(&:blank?).any?
        self.cards.delete(k)
      end
    end
  end
end
