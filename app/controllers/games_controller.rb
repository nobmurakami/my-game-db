class GamesController < ApplicationController

  def index
    @q = Game.ransack(params[:q])
    @q.sorts = 'metascore DESC' if @q.sorts.empty?
    @games = @q.result(distinct: true).page(params[:page]).per(10).order("created_at DESC")
    @platform_name = Platform.select("name").distinct.order("name ASC")
    @tag_name = Tag.select("name").distinct.order("name ASC")
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

  def destroy
    load_game
    @game.destroy
    redirect_to root_path
  end

  private

  def game_params
    params.require(:game_form).permit(:title, :image, :description, :metascore, :release_date, :platform_name, :tag_names, :genre_names, :developer_names, :publisher_names)
  end

  def load_game
    @game = Game.find(params[:id])
  end
end