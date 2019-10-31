ActiveAdmin.register VirtualDeck do
  scope :can_be_imported, default: true
  scope :all

  permit_params :deck_name
  filter :deck_name

  form do |f|
    f.semantic_errors # shows errors on :base
    f.input :deck_name
    f.actions
  end

  index do
    id_column
    column :user
    column :deck_name do |d|
      link_to d.deck_name,decks_path(filterrific: {with_deck_name: d.deck_name}), target: :_BLANK
    end
    column :has_similar_name?
    column :ready_for_import
    column :deck do |d|
      if d.deck.present?
        link_to d.deck.name, deck_path(d.deck.uuid)
      else
        "Not imported yet"
      end
    end
    column :u do |d|
      link_to "View as user", edit_virtual_deck_path(d.id)
    end
    column :admin do |d|
      link_to "Accept deck", import_admin_virtual_deck_path(d.id), data: {confirm: "Are you sure you want to import this deck?"}
    end
    actions
  end

  member_action :import, method: :get do
    deck = VirtualDeck.find(params[:id])
    if ImportVirtualDeckService.run(deck)
      redirect_to admin_virtual_decks_path, notice: "Deck imported"
    else
      flash[:warning] = "Could not import deck"
      redirect_to admin_virtual_decks_path
    end
  end
end
