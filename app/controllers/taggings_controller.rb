class TaggingsController < ApplicationController
  def create
    if tag_params[:tag].present?
      tag = Tag.find_or_create_by(name: tag_params[:tag].strip_all_space) 
      Tagging.find_or_create_by(game_id: tag_params[:game_id], tag_id: tag.id, user_id: tag_params[:user_id])
    end
      redirect_to game_path(tag_params[:game_id])
  end

  def destroy
    tagging = Tagging.find(params[:id])
    tagging.destroy
    redirect_to game_path(params[:game_id])
  end

  private

  def tag_params
    params.require(:tag).permit(:tag).merge(user_id: current_user.id, game_id: params[:game_id])
  end
end
