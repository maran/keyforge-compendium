class Api::V1::CardsController < Api::ApplicationController
  resource_description do
    short "The cards API lets you lookup all individual cards."
  end

  def_param_group :card do
    property :title, String, :desc => "Title of the card"
    property :number,Integer, :desc => "Official card number"
    property :card_type, String, :desc => "Card type"
    property :front_image, String, :desc => "URL to card image"
    property :text, String, :desc => "Card text"
    property :traits, String, :desc => "Card traits"
    property :rarity, String, :desc => "Card rarity"
    property :artist, String, :desc => "Card artist"
    property :house_name, String, :desc => "Card house name"
    property :amber,Integer, :desc => "Card bonus aember"
    property :power,Integer, :desc => "Card power"
    property :armor,Integer, :desc => "Card armor"
    property :cards_decks_count, Integer, :desc => "Card is present in # amount of decks"
    property :faqs, Hash, desc: "FAQs for this card" do
      property :id, Integer, desc: "FAQ id"
      property :question,String, desc: "FAQ question"
      property :answer,String, desc: "FAQ Answer"
    end
  end

  returns :card
  param :id, Integer, desc: 'Card number'
  param :set_id,[1,2], desc: 'Set id. 1 for "Call of the Archons", 2 for "Age of Ascension"'

  api :GET, '/cards/:id.json', "Show card details"
  api :GET, '/sets/:set_id/cards/:id.json', "Show card details for given set"
  def show
    get_set
    if @expansion.present?
      @card = @expansion.cards.no_mavericks.find_by(number: params[:id])
      unless @card.present?
        @card = @expansion.cards.no_mavericks.find_by(title: params[:id])
      end
    else
      not_found and return
    end

    if @card.present?
      respond_to do |format|
        format.json {render json: @card}
      end
    else
      not_found and return
    end
  end

  def index
    get_set

    if @expansion.present?
      @cards = @expansion.cards.no_mavericks.order(number: :asc).includes(:faqs).includes(:tags).includes(:a_house)
    else
      not_found and return
    end

    respond_to do |format|
      format.json {render json: @cards}
    end
  end

  def get_set
    if params[:set_id].present?
      @expansion = Expansion.find(params[:set_id])
    else
      @expansion = Expansion.find(1)
    end
  end

  #param :title, String, desc: 'Exact card title'
  #
  private
  def not_found
      render :json => {:error => "not-found"}.to_json, :status => 404
  end
end
