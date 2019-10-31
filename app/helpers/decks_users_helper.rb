module DecksUsersHelper
  def virtual_deck_link(vdeck)
    if vdeck.deck.present?
      link_to "Imported: #{vdeck.deck.name}", deck_path(vdeck.deck.uuid)
    else
      "Not imported yet"
    end
  end
end
