class UsersController < ApplicationController
  def show
    set_user
    @recommend_games = recommendation_for(@user).joins(:favorites).group(:game_id).order("count(user_id) desc").limit(5).with_attached_image.includes(:platform)
  end

  def want_to_play
    set_user
    @q = @user.want_games.ransack(params[:q])
    set_game_list
  end

  def playing
    set_user
    @q = @user.playing_games.ransack(params[:q])
    set_game_list
  end

  def played
    set_user
    @q = @user.played_games.ransack(params[:q])
    set_game_list
  end

  def favorite
    set_user
    @q = @user.favorite_games.ransack(params[:q])
    set_game_list
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
    if user.favorites.blank?
      Game.all
    else
      similar_users = user.similar_users
      similar_users_favorites = favorite_games_by(similar_users)

      recommend_games = similar_users_favorites - user.favorite_games
      Game.where(id: recommend_games.map(&:id))
    end
  end

  def set_user
    @user = User.find(params[:id])
  end

  def set_game_list
    @q.sorts = "favorites_count DESC" if @q.sorts.empty?
    @games = @q.result.page(params[:page]).per(10).order("created_at DESC").with_attached_image.includes(:platform)
  end
end
