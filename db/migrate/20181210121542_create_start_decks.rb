class CreateStartDecks < ActiveRecord::Migration[5.2]
  def up
    deck = Deck.new
    deck.name = "Miss \"Onyx\" Censorius"
    deck.uuid = "ed4346fa-3a4e-4559-8f0b-16054ee487bd"
    deck.house_ids = [4,6,2]
    deck.save
    [[1, 1], [1, 10], [1, 12], [1, 18], [1, 22], [1, 29], [2, 33], [2, 35], [1, 46], [1, 50], [1, 58], [1, 62], [2, 67], [1, 73], [1, 81], [2, 83], [1, 96], [1, 98], [1, 101], [1, 102], [2, 276], [1, 280], [1, 283], [1, 290], [1, 296], [1, 306], [1, 308], [1, 310], [1, 311], [2, 315]].each do |c|
      card = deck.cards_decks.build
      card.count = c[0]
      card.card_id = Card.where(is_maverick: false).find_by(number: c[1]).id
      card.save
    end
    deck.save

    deck = Deck.new
    deck.name = "Radiant Argus the Supreme"
    deck.uuid = "b8bd8cd6-5856-43ff-a0c8-cdec0d7d57d1"
    deck.house_ids = [5,7,3]
    deck.save
    [[1, 108], [1, 115], [1, 124], [2, 125], [1, 129], [2, 136], [1, 139], [1, 140], [1, 144], [1, 145], [2, 215], [1, 225], [1, 227], [1, 233], [1, 239], [1, 251], [2, 255], [1, 258], [1, 259], [1, 265], [1, 319], [1, 323], [1, 327], [1, 332], [1, 351], [2, 358], [2, 363], [1, 364], [1, 367], [1, 368]].each do |c|
      card = deck.cards_decks.build
      card.count = c[0]
      card.card_id = Card.where(is_maverick: false).find_by(number: c[1]).id
      card.save
    end
    deck.save
  end

  def down
    Deck.find_by(uuid: "ed4346fa-3a4e-4559-8f0b-16054ee487bd").delete
    Deck.find_by(uuid: "b8bd8cd6-5856-43ff-a0c8-cdec0d7d57d1").delete
  end
end
