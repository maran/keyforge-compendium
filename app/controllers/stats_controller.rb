class StatsController < ApplicationController
  def index
    @top_cards = Card.where(expansion_id: 1).where(is_maverick: false).order(cards_decks_count: :desc).limit(10)
    @bottom_cards = Card.where(expansion_id: 1).where(is_maverick: false).order(cards_decks_count: :asc).limit(10)
  end
end
