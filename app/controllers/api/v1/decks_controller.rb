class Api::V1::DecksController < Api::ApplicationController
  resource_description do
    short "The decks API lets you lookup individual decks and their various properties such as ADHD and SAS ratings."
  end

  def_param_group :uuids do
    property :uuid, String, :desc => "ID of the deck"
  end

  def_param_group :deck do
    property :name, String, :desc => "Name of the deck"
    property :uuid ,String, :desc => "ID of the deck"
    ['a','b','c','e','consistency','sas','cards','synergy'].each do |s|
      property "#{s}_rating", Float, :desc => "#{s.titleize}-rating of the deck"
    end
    Card.card_types[1..-1].each do |s|
      s = s[0].downcase
      property "#{s}_count",Integer, :desc => "#{s.titleize} count of the deck"
    end
    Card.rarities[1..-1].each do |s|
      s = s[0].downcase
      property "#{s}_count",Integer, :desc => "#{s.titleize} count of the deck"
    end
  end

  api :GET, '/decks/:id', "Show deck details"
  param :id, String, desc: 'id of the requested deck', required: true
  returns :deck
  def show
    @deck = Deck.find_by(uuid: params[:id])
    render json: @deck.as_json(params[:skip_cards])
  end

  api :GET, '/decks/', "List all decks"
  param :page_id, String, desc: 'paginated page id'
  returns :array_of =>:deck
  example <<-EOF
[{"name":"The Frivolous Malcontent of Gloomset","uuid":"f42f3b2f-e022-4c66-8e83-a7d8fb0bac6f","a_rating":28.3333266,"b_rating":15.999995,"c_rating":4.333331,"e_rating":5.666664,"consistency_rating":"0.246802","creature_count":14,"action_count":16,"artifact_count":5,"upgrade_count":1,"common_count":21,"rare_count":3,"fixed_count":0,"variant_count":0,"maverick_count":0,"sas_rating":92,"cards_rating":84,"synergy_rating":10}]
EOF
  returns array_of: :deck
  def index
    @decks = Deck.order(created_at: :desc).page(params[:page_id] || 1)
    render json: @decks
  end

  api :GET, '/decks/by_name/:name', "Search on decks by name"
  param :page_id, String, desc: 'paginated page id'
  param :name, String, desc: "Deck name to search for", required: true
  returns array_of: :deck
  def by_name
    if params[:name].length < 4
      render json: {error: "Name should be at least 4 characters long"}, code: 422
    else
      @decks = Deck.order(created_at: :desc).with_deck_name(params[:name]).page(params[:page_id] || 1)
      render json: @decks
    end
  end

  api :GET, '/decks/random/:amount', "Grab a few random deck IDs"
  param :amount, String, desc: "Amount of deck IDs to return.", required: false, default: 2
  returns array_of: :uuids
  def random
    params[:amount] ||= 2
    deck = Deck.select(:uuid).limit(params[:amount]).order((Arel.sql"RANDOM()"))
    render json: deck.collect(&:uuid).to_json
  end
end
