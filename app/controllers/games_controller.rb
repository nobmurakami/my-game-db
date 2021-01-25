class GamesController < ApplicationController

  def index
    @q = Game.ransack(params[:q])
    @games = @q.result(distinct: true).page(params[:page]).per(10).order("created_at DESC")
  end
  
  def new
    @form = GameForm.new
  end

  def create
    @form = GameForm.new(game_params)

    if @form.save
      redirect_to root_path
    else
      render :new
    end
  end

  def show
    load_game
  end

  def edit
    load_game
    @form = GameForm.new(game: @game) 
  end

  def update

    load_game
    @form = GameForm.new(game_params, game: @game)

    if @form.save
      redirect_to game_path(@game)
    else
      render :edit
    end
  end

  private

  def game_params
    params.require(:game_form).permit(:title, :image, :description, :metascore, :release_date, :platform_name, :region_name)
  end

  def load_game
    @game = Game.find(params[:id])
  end
end