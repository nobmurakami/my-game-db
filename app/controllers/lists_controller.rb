class ListsController < ApplicationController
  before_action :authenticate_user!
  
  def want
    new_list = current_user.want_lists.find_or_initialize_by(game_id: params[:game_id])
    save_list(new_list)
  end

  def playing
    new_list = current_user.playing_lists.find_or_initialize_by(game_id: params[:game_id])
    save_list(new_list)
  end

  def played
    new_list = current_user.played_lists.find_or_initialize_by(game_id: params[:game_id])
    save_list(new_list)
  end

  def destroy
    list = List.find_by(game_id: params[:game_id], user_id: current_user.id)
    list.destroy
    redirect_back(fallback_location: root_path)
  end

  private

  def save_list(new_list)
    if Game.find(params[:game_id]).is_listed_by?(current_user)
      List.transaction do
        old_list = current_user.lists.find_by(game_id: params[:game_id])
        old_list.destroy!
        new_list.save!
      end
    else
      new_list.save
    end
    redirect_back(fallback_location: root_path)
  end
end
