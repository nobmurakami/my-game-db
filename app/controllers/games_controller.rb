class GamesController < ApplicationController
  before_action :set_game, only: [:show, :edit, :update]

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
  end

  def edit
  end

  def update
    if @game.update(game_params)
      redirect_to game_path(@game)
    else
      render :edit
    end
  end

  private

  def game_params
    params.require(:game).permit(:title, :description, :metascore)
  end

  def set_game
    @game = Game.find(params[:id])
  end
end