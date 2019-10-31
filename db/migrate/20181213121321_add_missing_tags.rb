class AddMissingTags < ActiveRecord::Migration[5.2]
  def up
    tag = Tag.find_or_create_by(name: "Healers", description: "Cards that interact with creature health somehow")
    tag.cards << Card.where("text ILIKE ?", "%heal%")

    tag = Tag.find_or_create_by(name: "Stunners", description: "Cards that interact with stuns")
    tag.cards << Card.where("text ILIKE ?", "%stun%")

    tag = Tag.find_or_create_by(name: "Æmber Bonus", description: "Cards with an amber bonus on them.")
    tag.cards << Card.where("amber > 0")
  end

  def down
  end
end
