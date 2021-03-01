class TagsController < ApplicationController
  def show
    @tag = Tag.find(params[:id])
    @q = @tag.games.ransack(params[:q])
    @q.sorts = "favorites_count DESC" if @q.sorts.empty?
    @games = @q.result(distinct: true).page(params[:page]).per(10).order("created_at DESC")
               .with_attached_image.includes(:platform)
    @tags = Tag.joins(:taggings).group(:tag_id).order("count(user_id) desc").limit(20)
  end
end
