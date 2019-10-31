class FaqsController < ApplicationController
  def index
    if params[:deck_id].present?
      @deck = Deck.find_by(uuid: params[:deck_id])
      @cards = @deck.cards.order(title: :asc).includes(:faqs)
    else
      @cards = Card.where(is_maverick: false).order(title: :asc).includes(:faqs).all
    end
  end
end
