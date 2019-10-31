class Card < ApplicationRecord
  attr_accessor :amount

  has_many :cards_decks, dependent: :destroy
  has_many :decks, through: :cards_decks
  has_many :faqs
  has_many :synergies

  has_and_belongs_to_many :tags

  belongs_to :a_house, class_name: "House", foreign_key: :house_id
  belongs_to :expansion

  has_many :mavericks, foreign_key: :parent_id, class_name: "Card"
  belongs_to :base_card, foreign_key: :parent_id, class_name: "Card", optional: true, inverse_of: :mavericks

  before_save :check_base_and_sync

  def sanitize_text
    if self.text.present?
      # Strip out narrow no-break space
      self.text.gsub!("\u202F", " ")
    end
  end

  # If we are not a maverick we want to persist all changes to the mavericks that copy from us
  # so the cards are always in sync.
  def check_base_and_sync
    self.sanitize_text

    if self.is_maverick?
      Rails.logger.info("Updating maverick: #{self.id}")
      self.attributes = self.base_card.attributes.reject{|k,v| ["id","house","parent_id","uuid","created_at","house_id","is_maverick"].include?(k)}
    end
  end

  # Temporarily method for wrongly imported mavericks
  def reset_base_card
    new_card = Card.no_mavericks.find_by!(number: self.number, expansion_id: self.expansion.id)
    self.base_card = new_card
  end

  filterrific(
    default_filter_params: { sorted_by: 'number_asc' },
    available_filters: [
      :by_deck_id,
      :type_like,
      :sorted_by,
      :rarity_like,
      :search_title,
      :search_text,
      :with_power,
      :with_armor,
      :with_expansion,
      :with_tags,
      :with_traits,
      :house_like
  ]
  )

  scope :sorted_by, ->(sort_option) do
    direction = (sort_option =~ /desc$/) ? 'desc' : 'asc'
    case sort_option.to_s
    when /^number/
      reorder(number: direction)
    when /^title/
      reorder(title: direction)
    when /^house/
      reorder(house: direction)
    when /^card_type/
      reorder(card_type: direction)
    end
  end

  scope :rarity_like, ->(q) { where("rarity = ?",q)}

  scope :rarity_count_like, ->(rarity) do
    where("rarity = ?",rarity).select("count as card_counter").collect(&:card_counter).sum
  end

  scope :search_title, ->(q) { where("LOWER(title) LIKE ?", "%#{q.to_s.downcase}%") }
  scope :search_text, ->(q) { where("LOWER(text) LIKE ?", "%#{q.to_s.downcase}%") }
  scope :with_expansion, ->(exp_id) { where(expansion_id: exp_id) }
  scope :house_like, ->(house_id) { where("house_id = ?", house_id.to_i) }
  scope :type_like, ->(q) { where("card_type = ?", q) }

  scope :type_count_like, -> (t) do
    where("card_type= ?",t).select("count as card_counter").collect(&:card_counter).sum
  end

  scope :by_deck_id, ->(deck_id) do
    where("id IN (select card_id from cards_decks WHERE deck_id = ?)", deck_id)
  end

  scope :with_tags, -> (tag_id) { joins(:tags).where(tags: {id: tag_id}) }
  scope :with_traits, -> (trait) { where("traits ILIKE ?", "%#{trait}%") }
  scope :no_mavericks, -> {where(is_maverick: false) }
  scope :only_mavericks, -> {where(is_maverick: true) }
  scope :with_power,-> (power) {where("power >= ?", power) }
  scope :with_armor,-> (armor) {where("armor >= ?", armor) }

  def percentage_present_decks
    if self.cards_decks_count > 0
      return ((100 * self.cards_decks_count) / Deck.count.to_f).round(2)
    else
      return 0
    end
  end


  def update_counter_cache
    self.cards_decks_count = CardsDeck.where(card_id: self.id).count
  end

  # All methods below help the importer be lazy by simply giving the entire parsed json object to .attributes
  def card_number=(t)
    self.number = t.to_i
  end

  def house=(house)
    self.house_id = House.select("id").find_by(name: house).id
  end

  def expansion=(t)
    self.expansion_id = Expansion.select("official_id, id").find_by(official_id: t.to_i).id
  end

  def card_title=(t)
    self.title = t
  end

  def card_text=(t)
    self.text = t
  end

  def slug
    "#{self.number}-#{self.title}".parameterize
  end

  def house_name
    self.a_house.name
  end

  def pretty_name
    pname = self.title
    pname += " (#{self.a_house.name.titleize})" if self.is_maverick?
    return pname
  end

  def synergy_rating_for_deck(deck,  with_base = false)
    rating = self.synergies.with_cards(deck.normalised_card_ids).sum{|x| x.rating_for_deck(deck) }.round(4)
    if with_base
      rating += self.base_score
    end
    return rating
  end

  def self.options_for_virtual_deck_filter(house_id, with_maverick = true)
    Card.select("cards.id, cards.title, cards.is_maverick, cards.house_id, cards.expansion_id").where(house_id: house_id).order(title: :asc).eager_load(:a_house, :expansion).all.collect{|x| ["#{x.expansion.abbr} - #{x.pretty_name}", x.id]}.prepend("")
  end

  include ActionView::Helpers::TextHelper
  def meta_description
    [self.title, "##{self.number}", self.a_house.name, self.card_type, self.rarity, "present in #{self.cards_decks_count} decks", truncate(self.text, length: 50)].join(" · ")
  end

  def self.options_for_deck_filter(with_maverick = true)
    if with_maverick
      Card.select("cards.id, cards.title, cards.is_maverick, cards.house_id, cards.expansion_id").order(title: :asc).eager_load(:a_house, :expansion).all.collect{|x| ["#{x.expansion.abbr} - #{x.pretty_name}", x.id]}.prepend("")
    else
      Card.no_mavericks.select("cards.id, cards.title, cards.is_maverick, cards.house_id, cards.expansion_id").order(title: :asc).eager_load(:a_house, :expansion).all.collect{|x| ["#{x.expansion.abbr} - #{x.pretty_name}", x.id]}.prepend("")
    end
  end

  def all_set_faqs
    unless self.faqs.any?
      card = Card.where(title: self.title).where.not(expansion_id: self.expansion_id).where(is_maverick: false).first
      if card.present? && card.faqs.any?
        return card.faqs
      end
    else
      return self.faqs
    end

    return []
  end


  def self.options_for_sorted_by
    [
      ['Number', 'number_asc'],
      ['Title (a-z)', 'title_asc'],
      ['Type (a-z)', 'card_type_asc'],
      ['House (a-z)', 'house_asc'],
    ]
  end

  def self.rarities
    [
      [""],
       ["Rare"], ["Common"], ["Uncommon"], ["FIXED"], ["Variant"]
    ]
  end

  def self.card_types
    [
      [""],
      ["Creature"],
      ["Action"],
      ["Artifact"],
      ["Upgrade"]
    ]
  end

  def self.card_compare_types
    [">=", ">", "="]
  end

  def self.maverick_compare_types
    [">=",">", "<","="]
  end

  def as_json(options = {})
    super(options.reverse_merge(methods: :house_name, only: [:title, :front_image, :is_maverick,:artist, :card_type, :amber, :power, :armor, :rarity, :flavor_text, :number, :text, :traits, :cards_decks_count], include: [:faqs, :tags]))
  end
end
