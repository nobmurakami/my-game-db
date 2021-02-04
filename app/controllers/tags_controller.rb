class TagsController < ApplicationController
  def show
    @tag = Tag.find(params[:id])
    @q = @tag.games.ransack(params[:q])
    @q.sorts = 'metascore DESC' if @q.sorts.empty?
    @games = @q.result(distinct: true).page(params[:page]).per(10).order('created_at DESC')
    @tags = Tag.joins(:taggings).group(:tag_id).order('count(user_id) desc').limit(20)
  end
end
