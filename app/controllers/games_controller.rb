class GamesController < ApplicationController
  before_action :authenticate_user!

  def new
    @game = current_user.games.build
    unless current_user.decks.any?
      flash[:notice] = "You don't have any favourite decks yet, forcing all decks"
    end
  end

  def show
    @game = current_user.games.find(params[:id])
  end

  def destroy
    @game = current_user.games.find(params[:id])
    if @game.destroy
      redirect_to games_path, notice: "Game removed"
    else
      redirect_to games_path, notice: "Could not remove game"
    end
  end

  def create
    @game = current_user.games.build(game_params)
    if @game.save
      redirect_to games_path
    else
      render :new
    end
  end

  def index
    @games = current_user.games.order(played_at: :desc)
  end

  private
  def game_params
    params.require(:game).permit(:winning_deck_id, :losing_deck_id, :played_at, :notes)
  end
end
