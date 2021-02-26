class GenresController < ApplicationController
  def show
    @genre = Genre.find(params[:id])
    @q = @genre.games.ransack(params[:q])
    @q.sorts = "favorites_count DESC" if @q.sorts.empty?
    @games = @q.result(distinct: true).page(params[:page]).per(10).order("created_at DESC").with_attached_image.includes(:platform)
    @genres = Genre.joins(:game_genres).group(:genre_id).order("count(game_id) desc").limit(20)
  end
end
