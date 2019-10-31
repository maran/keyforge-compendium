class AddDefaultTagsAndCards < ActiveRecord::Migration[5.2]
  def up
    tag = Tag.find_or_create_by(name: "Omni presence", description: "Cards that let you use cards outside the select house or cards that work regardless of the current house")
    tag.cards << Card.where("text ILIKE ?", "%omni%")

    tag = Tag.find_or_create_by(name: "Destruction", description: "Cards that don't deal damage but destroy one or more cards outright")
    tag.cards << Card.where("text ilike ?", "%destroy %")

    tag = Tag.find_or_create_by(name: "Instant damage", description: "Cards that deal damage directly in one go without first having go ready, this will mostly be actions")
    tag.cards << Card.where("text ilike ?", "Play%deal%<D>%")

    tag = Tag.find_or_create_by(name: "Delayed damage", description: "Cards that deal damage but require a turn to get ready in some form or other")
    tag.cards << Card.where("text NOT LIKE ?", "%Play%").where("text ilike ?", "%deal%<D>%").where(card_type: ["Creature", "Artifact"])

    tag = Tag.find_or_create_by(name: "Mass damage", description: "Cards that can deal damage to more than one target at the same time")
    tag.cards << Card.where("text ilike ?", "%deal%<D>%each%")

    tag = Tag.find_or_create_by(name: "Reapers", description: "Creatures with reaper effects")
    tag.cards << Card.where("text ilike ?", "Reap%").where(card_type: "Creature")

    tag = Tag.find_or_create_by(name: "Battlecriers", description: "Creatures with play effects")
    tag.cards << Card.where("text ilike ?", "Play:%").where(card_type: "Creature")

    tag = Tag.find_or_create_by(name: "Brawlers", description: "Creatures with fight effects")
    tag.cards << Card.where("text ilike ?", "Fight:%").where(card_type: "Creature")

    tag = Tag.find_or_create_by(name: "Skirmishers", description: "Creatures with skirmish")
    tag.cards << Card.where("text ilike ?", "%skirmish%").where(card_type: "Creature")

    tag = Tag.find_or_create_by(name: "Elusives", description: "Creatures with elusive")
    tag.cards << Card.where("text ilike ?", "%elusive%").where(card_type: "Creature")

    tag = Tag.find_or_create_by(name: "Taunters", description: "Creatures with taunt")
    tag.cards << Card.where("text NOT LIKE ?", "%Niffle%").where("text ilike ?", "%taunt%").where(card_type: "Creature")

    tag = Tag.find_or_create_by(name: "Poisoners", description: "Creatures that poison")
    tag.cards << Card.where("text ilike ?", "%poison%").where(card_type: "Creature")

    tag = Tag.find_or_create_by(name: "Æmber haters", description: "Cards that destroy, capture or let a player lose aember")
    tag.cards << Card.where("((text LIKE ?) AND (text LIKE ?)) OR ((text LIKE ?) AND (text LIKE ?))", "%<A>%", "%capture%", "%<A>%", "%destroy%")

    tag = Tag.find_or_create_by(name: "Æmber thieves", description: "Cards that remove aember and add it to your own supply")
    tag.cards << Card.where("(text LIKE ?) AND (text LIKE ?)", "%<A>%", "%steal%")

    tag = Tag.find_or_create_by(name: "Purgers", description: "Cards with the ability to purge other cards")
    tag.cards << Card.where("text ILIKE ?", "%purge%")

    tag = Tag.find_or_create_by(name: "Archivists", description: "Cards that interact with the archive in some form")
    tag.cards << Card.where("text ILIKE ?", "%archive%")

    tag = Tag.find_or_create_by(name: "Draw engines", description: "Cards that let you draw")
    tag.cards << Card.where("text ILIKE ?", "%draw%")

    tag = Tag.find_or_create_by(name: "Key manipulators", description: "Cards that control how keyforging behaves")
    tag.cards << Card.where("text ILIKE ?", "%key%")

    tag = Tag.find_or_create_by(name: "Bouncers", description: "Cards that send cards back to hands from other areas")
    tag.cards << Card.where("text ILIKE ?", "%return%")

    tag = Tag.find_or_create_by(name: "Discarders", description: "Cards that interact with a discard pile")
    tag.cards << Card.where("text ILIKE ?", "%pile%")

    Card.card_types.reject(&:blank?).each do |c|
      tag = Tag.find_or_create_by(name: c[0])
      tag.hide_by_default = true
      tag.save
      tag.cards << Card.where(card_type: c[0])
    end

  end

  def down
  end
end
