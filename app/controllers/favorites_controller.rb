class FavoritesController < ApplicationController
  before_action :game_params

  def create
    favorite = current_user.favorites.build(game_id: params[:game_id])
    favorite.save
    # redirect_back(fallback_location: root_path)
  end

  def destroy
    favorite = Favorite.find_by(game_id: params[:game_id], user_id: current_user.id)
    favorite.destroy
    # redirect_back(fallback_location: root_path)
  end

  private

  def game_params
    @game = Game.find(params[:game_id])
  end
end
