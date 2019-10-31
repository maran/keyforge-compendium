class ChangeAllDecksToLegacySet < ActiveRecord::Migration[5.2]
  def up
    Deck.update_all(expansion_id: 1)
  end
end
