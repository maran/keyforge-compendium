class Deck < ApplicationRecord
  attr_accessor :list_image, :skip_caching

  filterrific(
    default_filter_params: { sorted_by: 'created_at_desc' },
    available_filters: [
      :sorted_by,
      :by_house,
      :with_deck_name,
      :with_cards,
      :with_card_ids,
      :with_adhd,
      :with_expansion_id,
      :with_sas,
      :with_maverick_count,
      :with_power_level,
      :with_card_count,
      :with_favourites,
      :with_for_sale,
      :with_common_count,
      :with_chains,
      :with_wins,
      :with_losses,
      :with_uncommon_count,
      :with_rare_count,
      :with_fixed_count,
      :with_variant_count,
      :without_card_ids,
    ]
  )

  has_many :cards_decks, dependent: :destroy
  has_many :cards, through: :cards_decks

  has_many :decks_users, dependent: :destroy
  has_many :users, through: :deck_users
  has_one :virtual_deck

  belongs_to :expansion

  has_and_belongs_to_many :houses, dependent: :destroy

  scope :house_like, ->(house_id) { where("house_id", house_id)}

  before_save :cache_attributes, unless: -> { self.skip_caching == true }

  validates :uuid, uniqueness: true

  scope :with_favourites, -> (favs) do
    if favs.present?
      where(id: favs.to_s.split(" "))
    end
  end

  scope :from_user, -> (user) do
    where(id: user.decks.select("id").collect(&:id))
  end

  scope :with_for_sale, -> (is_present) do
    if is_present.present? && is_present.to_s == "true"
      where(id: DecksUser.select(:deck_id).ids_for_sale.collect(&:deck_id).flatten)
    end
  end

  Card.rarities[1..-1].each do |t|
    t = t[0].downcase
    scope_name = "with_#{t}_count"
    scope scope_name, -> (count) do
      if count.present? && !count.is_a?(String) && count.count.present? && Card.maverick_compare_types.include?(count.type)
        where("#{t}_count #{count.type} ?", count.count)
      end
    end
  end

  scope :with_maverick_count, -> (count) do
    if count.present? && !count.is_a?(String) && count.count.present? && Card.maverick_compare_types.include?(count.type)
      where("maverick_count #{count.type} ?", count.count)
    end
  end

  scope :with_power_level, -> (count) do
    if count.present? && !count.is_a?(String) && count.count.present? && Card.maverick_compare_types.include?(count.type)
      where("power_level #{count.type} ?", count.count)
    end
  end

  scope :with_chains, -> (count) do
    if count.present? && !count.is_a?(String) && count.count.present? && Card.maverick_compare_types.include?(count.type)
      where("chains #{count.type} ?", count.count)
    end
  end

  scope :with_wins, -> (count) do
    if count.present? && !count.is_a?(String) && count.count.present? && Card.maverick_compare_types.include?(count.type)
      where("wins #{count.type} ?", count.count)
    end
  end

  scope :with_losses, -> (count) do
    if count.present? && !count.is_a?(String) && count.count.present? && Card.maverick_compare_types.include?(count.type)
      where("losses #{count.type} ?", count.count)
    end
  end

  scope :with_card_count, -> (count) do
    if count.is_a?(OpenStruct)
      result = Card.card_types[1..-1].collect do |i|
        i = i[0].downcase
        rating = count.send("#{i}_count")
        typer = count.send("#{i}_type")
        if rating.present? && [">","<","="].include?(typer)
          "#{i}_count #{typer} #{rating.to_f}"
        else
          next
        end
      end.reject(&:blank?).join(" AND ")

      where(result)
    end
  end

  scope :with_adhd, -> (adhd) do
    if adhd.is_a?(OpenStruct)
      result = ['a','b','c','e', 'consistency'].collect do |i|
        rating = adhd.send("#{i}_rating")
        typer = adhd.send("#{i}_type")
        if rating.present? && [">","<","="].include?(typer)
          "#{i}_rating #{typer} #{rating.to_f}"
        else
          next
        end
      end.reject(&:blank?).join(" AND ")

      where(result)
    end
  end

  scope :with_sas, -> (adhd) do
    if adhd.is_a?(OpenStruct)
      result = Deck.sas_options.collect do |i|
        rating = adhd.send("#{i}_rating")
        typer = adhd.send("#{i}_type")
        if rating.present? && [">","<","="].include?(typer)
          "#{i}_rating #{typer} #{rating.to_f}"
        else
          next
        end
      end.reject(&:blank?).join(" AND ")

      where(result)
    end
  end

  scope :with_expansion_id, -> (id) {
    where(expansion_id: id)
  }

  scope :with_deck_name, -> (name) {
    where("decks.name ILIKE :name OR decks.sanitized_name ILIKE :name",name: "%#{name}%")
  }

  scope :by_house, ->(houses) {
    if houses.house_ids.present?
      if houses.order_type == "Includes"
        includes(:houses).where("decks_houses.house_id IN (?)", houses.house_ids).joins("INNER JOIN decks_houses ON decks_houses.deck_id = decks.id").group("decks.id").having("count(distinct decks_houses.house_id) = #{houses.house_ids.length}")
      elsif houses.order_type == "Excludes"
        includes(:houses).where("decks_houses.house_id NOT IN (?)", houses.house_ids).joins("INNER JOIN decks_houses ON decks_houses.deck_id = decks.id").group("decks.id").having("count(distinct decks_houses.house_id) = 3")
      else
        includes(:houses).where("decks_houses.house_id IN (?)", houses.house_ids).joins("INNER JOIN decks_houses ON decks_houses.deck_id = decks.id").group("decks.id")
      end
    end
  }

  scope :with_card_ids, -> (cards) {
    card_data = cards.reject{|x| x.blank? || !x['card_id'].present? || !Card.card_compare_types.include?(x["card_type"])}
    if card_data.present?
      deck_query = card_data.collect{|item| "(card_id = #{item['card_id']} AND count #{item['card_type']} #{item['card_count']})"}.join(" OR ")
      deck_ids = CardsDeck.select("deck_id").where(deck_query).group(:deck_id).having("count(deck_id) = #{card_data.length}").collect(&:deck_id).flatten.uniq
      where("decks.id IN(?)", deck_ids)
    end
  }

  scope :with_cards, -> (cards) {
    card_data = cards.reject(&:blank?)
    if card_data.present?
      card_data = card_data.reject{|x| x['card_title'].blank? || !Card.card_compare_types.include?(x["card_type"])}
      res=card_data.collect{|x| [Card.select("cards.id, cards.title").where("LOWER (title) ILIKE ANY (array[?])", x["card_title"]).first.id, x["card_count"], x["card_type"]]}
      if res.length > 0
        deck_query = res.collect{|card_id, card_count, type| "(card_id = #{card_id} AND count #{type} #{card_count})"}.join(" OR ")
        deck_ids = CardsDeck.select("deck_id").where(deck_query).group(:deck_id).having("count(deck_id) = #{res.length}").collect(&:deck_id).flatten.uniq
        where("decks.id IN(?)", deck_ids)
      end
    end
  }

  scope :without_card_ids, -> (card_ids) {
    includes(:cards_decks).where.not(cards_decks: {card_id: card_ids})
  }
  # WITH excluded(item) AS (
#    VALUES(1), (2), (3), (4),(5)
#) SELECT COUNT("decks"."id") FROM decks INNER JOIN cards_decks t ON t.deck_id
# = decks.id LEFT OUTER JOIN excluded e on (t.card_id = e.item) where e.item IS NULL;

  scope :sorted_by, ->(sort_option) do
    direction = (sort_option =~ /desc$/) ? 'desc' : 'asc'
    case sort_option.to_s
    when /^a_rating/
      reorder(a_rating: direction)
    when /^creature_count/
      reorder(creature_count: direction)
    when /^action_count/
      reorder(action_count: direction)
    when /^artifact_count/
      reorder(artifact_count: direction)
    when /^consistency/
      reorder(consistency_rating: direction)
    when /^sas/
      reorder(sas_rating: direction)
    when /^name/
      reorder(name: direction)
    when /^created_at/
      reorder(created_at: direction)
    end
  end

  def self.global_rating(rating_type)
    key = "avg_#{rating_type}"
    setting = Setting.find_by(name: key)

    unless setting.present?
      Setting.save_avg
      setting = Setting.find_by(name: key)
    end

    setting.value.to_f
  end

  def diff_from_global(rating_type = :a_rating)
    if self.send(rating_type).nil?
      self.cache_attributes
    end

    (self.send(rating_type) - Deck.global_rating(rating_type)).round(2)
  end

  def card_count(card)
    self.cards_decks.find_by(card_id: card.id).count
  end

  # Swaps out any mavericks with normal variations
  def normalised_card_ids
    ids = self.cards.no_mavericks.collect(&:id)
    ids << self.cards.only_mavericks.collect(&:parent_id)
    ids.flatten!
    return ids
  end

  def rating(rating_type = :a_weight)
    cards = self.cards_decks.collect{|x| [x.card_id, x.count]}
    cards.collect do |card_id, count|
      Card.select(rating_type).find(card_id).send(rating_type) * count
    end.sum.round(2)
  end

  def sanitize_name
    I18n.transliterate(self.name).gsub(/[^a-z0-9\s]/i, '')
  end

  def get_sas_rating
    unless self.sas_rating.present?
      self.update_sas_rating
    end

    return self.sas_rating
  end

  def update_sas_rating
    sas = SasService.run(self.uuid)

    self.skip_caching = true
    self.update_attributes(sas_rating: sas["sasRating"], cards_rating: sas["cardsRating"], synergy_rating: sas["synergyRating"], anti_synergy_rating: sas["antisynergyRating"])

    return sas
  end

  def cache_attributes
    # Right now there are some decks who have cards that were deleted at one point. This check should be a temp work around to reimport these
    if self.cards_decks.select('cards_decks.id').count > 0
      cd = self.cards_decks.select("cards_decks.*, cards.a_weight, cards.b_weight, cards.c_weight, cards.e_weight, (cards_decks.count * cards.a_weight) as a_score, (cards_decks.count * cards.b_weight) as b_score, (cards_decks.count * cards.c_weight) as c_score, (cards_decks.count * cards.e_weight) as e_score").joins("JOIN cards on cards.id = cards_decks.card_id")
      self.a_rating = cd.sum(&:a_score)
      self.b_rating = cd.sum(&:b_score)
      self.c_rating =  cd.sum(&:c_score)
      self.e_rating = cd.sum(&:e_score)
      # TODO: We can probably speed this up if needed
      self.consistency_rating = ['a','b','c','e'].sum{|x| self.std_rating("#{x}_rating")} / 4

      self.uncommon_count = self.cards.rarity_count_like("Uncommon")
      self.common_count = self.cards.rarity_count_like("Common")
      self.rare_count = self.cards.rarity_count_like("Rare")
      self.variant_count = self.cards.rarity_count_like("Variant")
      self.fixed_count = self.cards.rarity_count_like("FIXED")

      self.maverick_count = self.cards.only_mavericks.count

      Card.card_types[1..-1].each do |t|
        self.send("#{t[0].downcase}_count=",self.cards.type_count_like(t))
      end

      self.card_hash = HashCardsService.run(self.keyforge_com_card_ids_array)
      self.sanitized_name = self.sanitize_name
    end

    return true
  end

  def keyforge_com_card_ids_array
    self.cards_decks.collect do |c|
      raise c.inspect if c.card.nil?
      c.count.times.collect { c.card.uuid }
    end.flatten
  end

  def std_rating(rating_type)
    key = "std_#{rating_type}"
    setting = Setting.find_by(name: key)

    unless setting.present?
      Setting.save_std
      setting = Setting.find_by(name: key)
    end

    res = self.diff_from_global(rating_type) / setting.value.to_f
  end

  def self.full_adhd_values
    ['consistency','a','b','c','e']
  end

  def get_rating(rating_type)
    self.send("#{rating_type}_rating").round(3)
  end

  def get_consistency_rating
    unless self.consistency_rating.present?
      self.cache_attributes
    end

    return self.consistency_rating
  end

  def refresh_deck
    ImportDeckService.refresh(self.uuid)
  end

  def win_rate
    total = wins.to_i + losses.to_i
    (100.0 * wins / total).round(2)
  end

  def for_sale?
    self.decks_users.where(reason: DecksUser::REASON_SALE).any?
  end

  def total_score
    self.a_rating + self.b_rating + self.c_rating + self.e_rating
  end

  def self.sas_options
    ['sas','cards','synergy','anti_synergy']
  end

  def self.options_for_sorted_by
    [
      ['Consistency (desc)', 'consistency_desc'],
      ['Consistency (asc)', 'consistency_asc'],
      ['SAS Rating (desc)', 'sas_rating_desc'],
      ['SAS Rating (asc)', 'sas_rating_asc'],
      ['Creatures (desc)', 'creature_count_desc'],
      ['Creatures (asc)', 'creature_count_asc'],
      ['Actions (desc)', 'action_count_desc'],
      ['Actions (asc)', 'action_count_asc'],
      ['Artifacts (desc)', 'artifact_count_desc'],
      ['Artifacts (asc)', 'artifact_count_asc'],
      ['Name (a-z)', 'name_asc'],
    ]
  end

  def full_cards_as_json
    self.cards_decks.collect do |cd|
      cd.card.as_json(include: []).merge(count: cd.count)
    end
  end

  def self.describe_own_properties
    [
      Apipie::prop(:name, 'string', {:description => 'Name of the deck', :required => false}),
      Apipie::prop(:uuid, 'string', {:description => 'ID of the deck', :required => false}),
    ]
  end

  def house_names
    self.houses.collect(&:name)
  end

  def as_json(options = {})
    default_options = {methods: [:house_names],only: [:a_rating,:b_rating,:c_rating,:e_rating,:consistency_rating, :sas_rating, :cards_rating,:synergy_rating, :creature_count, :action_count, :artifact_count, :upgrade_count, :uncommon_count, :common_count, :rare_count, :fixed_count, :variant_count, :maverick_count, :name, :uuid]}
    if options.present?
      super(default_options)
    else
      super(default_options).merge({cards: full_cards_as_json})
    end
  end
end
