class ListsController < ApplicationController
  def want
    list = current_user.want_lists.find_or_initialize_by(game_id: params[:game_id])
    list.save
    redirect_to game_path(params[:game_id])
  end

  def playing
    list = current_user.playing_lists.find_or_initialize_by(game_id: params[:game_id])
    list.save
    redirect_to game_path(params[:game_id])
  end

  def played
    list = current_user.played_lists.find_or_initialize_by(game_id: params[:game_id])
    list.save
    redirect_to game_path(params[:game_id])
  end

  def destroy
    list = List.find_by(game_id: params[:game_id], user_id: current_user.id)
    list.destroy
    redirect_to game_path(params[:game_id])
  end
end
