class TaggingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_game
  before_action :set_tags

  def create
    if tag_params[:tag].present?
      tag = Tag.find_or_create_by(name: tag_params[:tag].strip_all_space)
      Tagging.find_or_create_by(game_id: tag_params[:game_id], tag_id: tag.id, user_id: tag_params[:user_id])
    end
  end

  def destroy
    tagging = Tagging.find(params[:id])
    tagging.destroy
  end

  private

  def tag_params
    params.require(:tag).permit(:tag).merge(user_id: current_user.id, game_id: params[:game_id])
  end

  def set_game
    @game = Game.find(params[:game_id])
  end

  def set_tags
    @tags = Tag.joins(:taggings).where(taggings: { game_id: @game }).group(:tag_id).order("count(user_id) desc").limit(10)
  end
end
