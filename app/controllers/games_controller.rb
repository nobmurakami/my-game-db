class GamesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]

  def index
    @q = Game.ransack(params[:q])
    @q.sorts = 'metascore DESC' if @q.sorts.empty?
    @games = @q.result(distinct: true).page(params[:page]).per(10).order('created_at DESC')
    @platform_names = Platform.all.order('name ASC').pluck(:name)
    @tag_names = Tag.all.order('name ASC').pluck(:name)
    @genre_names = Genre.all.order('name ASC').pluck(:name)
    @company_names = Company.all.order('name ASC').pluck(:name)
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
    params.require(:game_form).permit(:title, :image, :description, :metascore, :release_date, :platform_name, :tag_names,
                                      :genre_names, :developer_names, :publisher_names).merge(user_id: current_user.id)
  end

  def load_game
    @game = Game.find(params[:id])
  end
end
