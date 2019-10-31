class VirtualDecksController < ApplicationController
  before_action :authenticate_user!

  def find_deck
    if current_admin_user.present?
      @virtual_deck = VirtualDeck.find(params[:id])
    else
      @virtual_deck = current_user.virtual_decks.find(params[:id])
    end
  end

  def destroy
    @virtual_deck = current_user.virtual_decks.find(params[:id])
    if @virtual_deck.destroy
      redirect_to decks_users_path, notice: "Deck destroyed."
    end
  end

  def new
    @deck = Deck.new
  end

  def update
    find_deck
    @virtual_deck.update_attributes(deck_params)
    redirect_to edit_virtual_deck_path(@virtual_deck)
  end

  def edit
    find_deck

    #TODO: Potentially we could change this to only display all cards from the house of the select thing
    @card_selects = {}
    @virtual_deck.cards.keys.each do |k|
      @card_selects[k] = Card.options_for_virtual_deck_filter(k)
    end
  end

  def create
    if params.has_key?(:deck)
      uploaded_io = params[:deck][:list_image]
      file_path = Rails.root.join('public', 'uploads', uploaded_io.original_filename)
      File.open(file_path, 'wb') do |file|
        file.write(uploaded_io.read)
      end

      deck_list, raw = ParseDeckListService.from_image(file_path)
      vdeck = current_user.virtual_decks.build(raw_text: raw, cards: deck_list)
      vdeck.image.attach(io: File.open(file_path), filename: uploaded_io.original_filename)
      vdeck.save
      redirect_to edit_virtual_deck_path(vdeck)
    else
      flash.now[:warning] = "Please select a file"
      redirect_to new_virtual_deck_path
    end

  end

  def deck_params
    params.require(:virtual_deck).permit(:deck_name, :ready_for_import, cards: {})
  end
end
