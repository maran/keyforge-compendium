class DecksUsersController < ApplicationController
  before_action :authenticate_user!

  def new
    @deck_user = current_user.decks_users.build
    @deck_user.category = @deck_user.build_category
  end

  def show
    @deck_user = current_user.decks_users.find(params[:id])
    @deck = @deck_user.deck
  end

  def destroy
    @deck_user = current_user.decks_users.find(params[:id])
    if @deck_user.destroy
      redirect_to decks_users_path
    end
  end

  def edit
    @deck_user = current_user.decks_users.find(params[:id])
    if @deck_user.category.nil?
      @deck_user.build_category
    end
  end

  def update
    @deck_user = current_user.decks_users.find(params[:id])

    param = deck_params
    if deck_params.has_key?(:category_attributes) && deck_params[:category_attributes].has_key?(:name)
      param[:category_attributes][:user_id] = current_user.id
    else
      param.delete(:category_attributes)
    end

    if @deck_user.update_attributes(param)
      redirect_to decks_users_path
    else
      render :edit
    end
  end

  def index
    @deck_users = current_user.decks_users.includes(:deck)
    @virtual_decks = current_user.virtual_decks
  end

  def create
    # This is the heart being pressed
    if params[:id].present?
      @deck = Deck.find(params[:id])
      if current_user.present?
        if @deck.present?
          unless current_user.deck_ids.include?(@deck.id)
            current_user.decks << @deck
            render json: true
          else
            current_user.decks.delete(@deck)
            render json: false
          end
        end
      end
    else
      para = deck_params
      @deck_user = current_user.decks_users.build(para)
      unless para.has_key?(:category_id) && para.fetch(:category_id).present?
        if @deck_user.category.present? && @deck_user.category.new_record?
          @deck_user.category.user = current_user
        end
      end

      if @deck_user.save
        redirect_to decks_users_path
      else
        render :new
      end
    end
  end

  def deck_params
    params.require(:decks_user).permit(:deck_id, :reason, :category_id, :notes,category_attributes: [:name])
  end
end
