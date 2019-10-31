class DecksController < ApplicationController
  autocomplete :deck, :name, full: true, display_value: :name, column_name: :sanitized_name, extra_data: [:name]

  layout "image", only: :list
  def autocomplete_deck_name
    @decks = Deck.select(:id, :name, :sanitized_name).where("name ILIKE :name OR sanitized_name ILIKE :name", name: "%#{params[:term]}%").order(:sanitized_name).limit(10)
    render :json => @decks.map {|d| {id: d.id, label: d.name, value: d.name} }
  end

  def synergy
    @deck = Deck.find_by(uuid: params[:id])
  end

  def sas
    d = Deck.find_by(uuid: params[:id])

    if d.present? && !d.uuid.include?("VIRTUAL") && !["b8bd8cd6-5856-43ff-a0c8-cdec0d7d57d1","ed4346fa-3a4e-4559-8f0b-16054ee487bd"].include?(params[:id])
      sas = d.update_sas_rating
      if sas.present?
        render json: sas
      else
        render json: {}
      end
    else
      render json: {}
    end
  end

  def image
   if doing_request
     flash[:warning] = "You are already generating an image, please wait at least five seconds."
     redirect_to deck_path(params[:id]) and return
   end

   if Deck.exists?(uuid: params[:id])
      @kit = IMGKit.new(list_deck_url(params[:id]), quality: 35, width: 700)
      begin
        respond_to do |format|
          format.png do
            send_data(@kit.to_png, :type => "image/png", :disposition => 'attachment', filename: "#{params[:id]}.png")
          end
        end
      rescue IMGKit::CommandFailedError
        flash[:warning] = "Could not generate image, try it again later"
        redirect_to deck_path(params[:id])
      end
   else
     flash[:warning] = "Deck does not exist"
     redirect_to deck_path(params[:id])
   end
  end

  def list
    @deck = Deck.find_by(uuid: params[:id])
    if @deck.present?
      @cards = @deck.cards
    else
      render html: "Deck does not exist",  status: :not_found
    end
  end

  def new
    @deck = Deck.new(id: params[:deck_id])
  end

  def new_card_filter
    render partial: "/decks/card_filter", locals: {card_title: nil, card_count: nil, card_type: nil, card_id: nil}
  end

  def tags
    @deck = Deck.find_by(uuid: params[:id])
    @cards= @deck.cards_decks.where(card_id: @deck.card_ids).eager_load(card: :tags)
    @cards.each do |c|
      c.tags.each do |t|
        t.virtual_cards ||= []
        c.card.amount = c.count
        t.virtual_cards << c.card
        t.virtual_count = t.virtual_cards.sum(&:amount)
      end
    end
    @tags = @cards.collect(&:tags).flatten.uniq.sort_by{|x| -x.virtual_count}
  end

  def random
    render json: {message: "Please use the new API, see https://keyforge-compendium.com/api_keys"}
  end

  def compare
    @deck = Deck.find_by(uuid: params[:id])
    if params[:deck_id].present?
      @other_deck = Deck.find(params[:deck_id])
    elsif params[:uuid].present?
      @other_deck = Deck.find_by(uuid: params[:uuid])
    end
  end

  def index
    if params[:user_id].present?
      @user = User.find_by(id: params[:user_id])
      unless @user.present?
        @user = User.find_by(username: params[:user_id].downcase)
      end
      params[:filterrific] ||= {}
    end

    @filterrific = initialize_filterrific(
      Deck,
      params[:filterrific],
      select_options: {
      sorted_by: Deck.options_for_sorted_by,
      by_house:  House.all.collect{|x| [x.id,x.name]},
      }, persistence_id: false
    ) or return
    if @user.present? && @user.favourites_public?
      @results = @filterrific.find.from_user(@user)
    else
      @results = @filterrific.find
    end

    res = @results.count
    if res.is_a?(Hash)
      @deck_amount = res.keys.length
    else
      @deck_amount = res
    end
    @decks = @results.page(params[:page]).per(20).without_count
  end

  def delayed_refresh
    RefreshDeckWorker.perform_async(params[:id])
    redirect_to deck_path(params[:id]), notice: "Your request has been queued and the deck will be updated shortly."
  end

  def create
    deck_id = params[:deck][:id]
    if deck_id.include?("keyforgegame.com/deck-details/")
      result = deck_id.match(/((\w*-){4}\w*)$/)
      if result.present? && result.size == 3
        deck_id = result[1]
      end
    end

    if deck_id.count("-") == 4
      @deck = Deck.find_or_initialize_by(uuid: deck_id)
      if @deck.new_record?
        @deck.with_lock do
          if ImportDeckService.new(@deck, deck_id)
            redirect_to deck_path(deck_id),notice: "Successfully imported deck"
          else
            flash[:notice] = "Could not important deck with id '#{@deck.uuid}'"
            render :new and return
          end
        end
      else
        redirect_to deck_path(deck_id), notice: "Deck already imported"
      end
    else
      flash[:notice] = "Could not important deck with id '#{deck_id}'"
      redirect_to new_deck_path
    end
  end

  def show
    @deck = Deck.find_by(uuid: params[:id])
    if @deck.present?
      params[:filterrific] ||= {}

      @filterrific = initialize_filterrific(
        Card,
        params[:filterrific].reverse_merge(by_deck_id: @deck.id),
          select_options: {
          type_like: Card.card_types,
          house_like: @deck.houses.collect{|x| [x.name,x.id]}.prepend(""),
          rarity_like: Card.rarities,
          sorted_by: Card.options_for_sorted_by}
      ) or return
      @cards = @filterrific.find
    else
      redirect_to new_deck_path(deck_id: params[:id]), notice: "Deck not imported yet, you may do so now"
    end
  end

  protected
  def doing_request
    conf_key = "user_ip_#{request.remote_ip}_count"

    if Rails.cache.read(conf_key).present?
      return true
    else
      Rails.cache.write(conf_key, true, :expires_in => 5.second)
      return false
    end
  end
end
