class PlatformsController < ApplicationController
  def show
    @platform = Platform.find(params[:id])
    @q = @platform.games.ransack(params[:q])
    @q.sorts = "favorites_count DESC" if @q.sorts.empty?
    @games = @q.result.page(params[:page]).per(10).order("created_at DESC").with_attached_image.includes(:platform)
    @platforms = Platform.joins(:games).group(:platform_id).order("count(platform_id) desc").limit(20)
  end
end
