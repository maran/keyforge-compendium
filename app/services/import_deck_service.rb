require 'net/http'

class ImportDeckService
  def self.update_deck_from_card_and_links(deck,card_data,links)
    ImportDeckService.update_deck_from_json(deck,HashWithIndifferentAccess.new({"data" => card_data, "_linked": links}))
  end

  def self.update_deck_from_json(deck,p)
    s = Time.now
    Rails.logger.info("Starting #{deck.uuid} @ #{Time.now}")

    d= p["data"]

    deck_exp = Expansion.find_by(official_id: d['expansion'])

    deck.uuid = d["id"]
    deck.name = d["name"]
    deck.expansion = deck_exp

    deck.cards = []
    created_card_ids = []

    if deck.new_record?
      hash = HashCardsService.run(d["_links"]["cards"])
      current_deck = Deck.find_by(card_hash: hash)
      if current_deck.present? && current_deck.virtual_deck.present?
        current_deck.uuid = deck.uuid
        current_deck.name = deck.name
        current_deck.virtual_deck.destroy
        current_deck.save
        return true
      end
    end

    d["_links"]["cards"].each do |card_uuid|
      card = p["_linked"]["cards"].select{|x| x['id'] == card_uuid}.first
      count = d["_links"]["cards"].count(card_uuid)

      # We don't want duplicate records
      next if created_card_ids.include?(card['id'])


      # If this card is a Maverick we will first locate the base card, the card it inherits from
      # And then find it or create the Maverick card if it's new
      if card["is_maverick"].to_s == "true"
        expansion = Expansion.find_by(official_id: card['expansion'])

        new_card = Card.no_mavericks.find_by!(number: card['card_number'], expansion_id: expansion.id)

        attrs = {uuid: card['id'], house_id: House.find_by(name: card['house']).id, is_maverick: true, expansion_id: expansion.id}

        m = Card.find_or_initialize_by(attrs)
        m.base_card = new_card
        m.save

        # By some dark magic, probably the before filter, the id is not being set on this attribute, that's why we are reloading it.
        m=Card.find_by(attrs)

        cd = CardsDeck.create!(deck: deck, card: m,count: count)
        created_card_ids << m.uuid
      else
        new_card = Card.find_or_initialize_by(uuid: card['id'])

        new_card.with_lock do
          if new_card.new_record? || new_card.expansion_id == 3
            new_card.attributes = card.reject{|x| x == 'id'}
            new_card.save
          end
        end

        CardsDeck.create!(deck: deck, card_id: new_card.id,count: count)
        created_card_ids << new_card.uuid
      end
    end


    deck.houses = []

    d["_links"]["houses"].each do |name|
      deck.houses << House.find_by(name: name)
    end

    deck.chains = d["chains"]
    deck.power_level = d["power_level"]
    deck.wins = d["wins"]
    deck.losses = d["losses"]

    deck.save

    deck.touch

    elapsed = Time.now - s
    Rails.logger.info("End #{deck.uuid} in #{elapsed}")
  end

  def self.refresh(uuid)
    deck = Deck.find_by(uuid: uuid)
    ImportDeckService.new(deck, deck.uuid)
  end

  def initialize(deck, uuid)
    url = URI("https://www.keyforgegame.com/api/decks/#{uuid}/?links=cards")
    res = Net::HTTP.get(url)
    p = JSON.parse(res)
    unless p.has_key?("code")
      ImportDeckService.update_deck_from_json(deck,p)
    else
      return false
    end
  end
end
