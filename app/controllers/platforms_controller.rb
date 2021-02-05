class PlatformsController < ApplicationController
  def show
    @platform = Platform.find(params[:id])
    @q = @platform.games.ransack(params[:q])
    @q.sorts = "metascore DESC" if @q.sorts.empty?
    @games = @q.result.page(params[:page]).per(10).order("created_at DESC")
    @platforms = Platform.joins(:games).group(:platform_id).order("count(platform_id) desc").limit(20)
  end
end
