class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @recommend_games = recommendation_for(@user).joins(:favorites).group(:game_id).order("count(user_id) desc").limit(5)
  end

  def want_to_play
    @user = User.find(params[:id])
    @q = @user.want_games.ransack(params[:q])
    @q.sorts = "metascore DESC" if @q.sorts.empty?
    @games = @q.result.page(params[:page]).per(10).order("created_at DESC")
  end

  def playing
    @user = User.find(params[:id])
    @q = @user.playing_games.ransack(params[:q])
    @q.sorts = "metascore DESC" if @q.sorts.empty?
    @games = @q.result.page(params[:page]).per(10).order("created_at DESC")
  end

  def played
    @user = User.find(params[:id])
    @q = @user.played_games.ransack(params[:q])
    @q.sorts = "metascore DESC" if @q.sorts.empty?
    @games = @q.result.page(params[:page]).per(10).order("created_at DESC")
  end

  def favorite
    @user = User.find(params[:id])
    @q = @user.favorite_games.ransack(params[:q])
    @q.sorts = "metascore DESC" if @q.sorts.empty?
    @games = @q.result.page(params[:page]).per(10).order("created_at DESC")
  end

  private

  def favorite_games_by(similar_users)
    favorite_games = []

    similar_users.each do |user|
      user.favorite_games.each do |game|
        favorite_games.push(game)
      end
    end
    Game.where(id: favorite_games.uniq.map(&:id))
  end

  def recommendation_for(user)
    similar_users = user.similar_users
    similar_users_favorites = favorite_games_by(similar_users)

    recommend_games = similar_users_favorites - user.favorite_games
    Game.where(id: recommend_games.map(&:id))
  end
end
