class GamesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_titles
  before_action :set_platform_names

  def index
    @q = Game.ransack(params[:q])
    @q.sorts = "favorites_count DESC" if @q.sorts.empty?
    @games = @q.result(distinct: true).page(params[:page]).per(10).order("created_at DESC")
               .with_attached_image.includes(:platform)
    if @header_search
      @games = @q_header.result(distinct: true).page(params[:page]).per(10).order("created_at DESC")
                        .with_attached_image.includes(:platform)
    end
    @tag_names = Tag.joins(:taggings).group(:tag_id).order("count(user_id) desc").limit(10).pluck(:name)
    @genre_names = Genre.all.order("name ASC").pluck(:name)
    @company_names = Company.all.order("name ASC").pluck(:name)
  end

  def new
    @form = GameForm.new
  end

  def create
    @form = GameForm.new(game_params)
    if @form.valid?
      @game = @form.save
      redirect_to game_path(@game)
    else
      render :new
    end
  end

  def show
    load_game
    @tags = Tag.joins(:taggings).where(taggings: { game_id: @game }).group(:tag_id).order("count(user_id) desc").limit(10)
    @your_tag = Tag.new
    @tag_names = Tag.joins(:taggings).group(:tag_id).order("count(user_id) desc").limit(10).pluck(:name)

    @recommend_games = recommendation_for(@game).joins(:favorites).group(:game_id).order("count(user_id) desc").limit(10)
                                                .with_attached_image.includes(:platform)
  end

  def edit
    load_game
    @form = GameForm.new(game: @game)
  end

  def update
    load_game
    @form = GameForm.new(game_params, game: @game)

    if @form.valid?
      @form.save
      redirect_to game_path(@game)
    else
      render :edit
    end
  end

  # def destroy
  #   load_game
  #   @game.destroy
  #   redirect_to root_path
  # end

  def delete_image_attachment
    load_game
    @image = @game.image
    @image.purge
    redirect_to game_path(@game)
  end

  private

  def game_params
    params.require(:game_form).permit(:title, :image, :description, :metascore, :release_date, :platform_name,
                                      :genre_names, :developer_names, :publisher_names, :steam,
                                      :youtube).merge(user_id: current_user.id)
  end

  def load_game
    @game = Game.find(params[:id])
  end

  def recommendation_for(game)
    recommend_games = []
    game.favorite_users.includes(:favorites, :favorite_games).each do |user|
      user.favorite_games.each do |other_game|
        recommend_games.push(other_game) unless other_game == game
      end
    end
    game.list_users.includes(:lists, :list_games).each do |user|
      user.list_games.each do |other_game|
        recommend_games.push(other_game) unless other_game == game
      end
    end
    Game.where(id: recommend_games.uniq.map(&:id))
  end

  def set_titles
    @titles = Game.all.order("title ASC").pluck(:title)
  end

  def set_platform_names
    @platform_names = Platform.all.order("name ASC").pluck(:name)
  end
end
