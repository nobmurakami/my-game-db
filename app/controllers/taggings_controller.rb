class TaggingsController < ApplicationController
  before_action :authenticate_user!

  def create
    if tag_params[:tag].present?
      tag = Tag.find_or_create_by(name: tag_params[:tag].strip_all_space)
      Tagging.find_or_create_by(game_id: tag_params[:game_id], tag_id: tag.id, user_id: tag_params[:user_id])
    end
    redirect_back(fallback_location: root_path)
  end

  def destroy
    tagging = Tagging.find(params[:id])
    tagging.destroy
    redirect_back(fallback_location: root_path)
  end

  private

  def tag_params
    params.require(:tag).permit(:tag).merge(user_id: current_user.id, game_id: params[:game_id])
  end
end
