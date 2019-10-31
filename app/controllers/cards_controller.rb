class CardsController < ApplicationController
  autocomplete :card, :title, full: true,  display_value: :pretty_name, extra_data: [:house_id, :is_maverick]

  def synergy
    card_number = params[:id].to_i
    @card = Card.find_by(number: params[:id], is_maverick: false)
  end

  def index
    params[:filterrific] ||= {}

    if params[:set_id].present?
      params[:filterrific].reverse_merge!(with_expansion: params[:set_id], sorted_by: "number_asc")
    else
      params[:filterrific].reverse_merge!(with_expansion: 2, sorted_by: "number_asc")
    end

    if params[:filterrific].has_key?(:with_expansion) && params[:filterrific][:with_expansion].present?
      @expansion = Expansion.find(params[:filterrific][:with_expansion])
      if params[:set_id].present? && params[:set_id] != @expansion.slug
        redirect_to set_cards_path(@expansion.slug), status: 301
      end
    end

    @filterrific = initialize_filterrific(
      Card,
      params[:filterrific],
       persistence_id: false,
        select_options: {
        sorted_by: Card.options_for_sorted_by,
        rarity_like: Card.rarities,
        house_like: House.all.collect{|x|[x.name, x.id]}.prepend(""),
        type_like: Card.card_types}
    ) or return

    @cards = @filterrific.find.where(is_maverick: false)
  end

  def show
    card_number = params[:id].to_i
    expansion_id = params[:set_id] || 1
    @card = Expansion.find(expansion_id).cards.find_by(number: params[:id], is_maverick: false)
    if @card.present?
      if params[:id] != @card.slug
        redirect_to set_card_path(expansion_id,@card.slug), status: 301
      end
    else
      redirect_to cards_path, alert: "Could not find requested card."
    end
  end

  def permit_params
    params.require[:filterrific].permit(by_house:{})
  end
end
