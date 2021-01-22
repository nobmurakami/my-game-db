class GamesController < ApplicationController
  def index
    @games = Game.page(params[:page]).per(10).order("created_at DESC")
  end
  
  def new
    @game = Game.new
  end

  def create
    @game = Game.new(game_params)
    if @game.save
      redirect_to root_path
    else
      render :new
    end
  end

  def show
    @game = Game.find(params[:id])
  end

  private

  def game_params
    params.require(:game).permit(:title, :description, :metascore)
  end
end