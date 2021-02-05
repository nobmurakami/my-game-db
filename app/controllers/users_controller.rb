class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
  end

  def want_to_play
    @user = User.find(params[:id])
    @q = @user.want_games.ransack(params[:q])
    @q.sorts = "metascore DESC" if @q.sorts.empty?
    @games = @q.result.page(params[:page]).per(10).order("created_at DESC")


  end

  def playing
    @user = User.find(params[:id])
    @q = @user.playing_games.ransack(params[:q])
    @q.sorts = "metascore DESC" if @q.sorts.empty?
    @games = @q.result.page(params[:page]).per(10).order("created_at DESC")
  end

  def played
    @user = User.find(params[:id])
    @q = @user.played_games.ransack(params[:q])
    @q.sorts = "metascore DESC" if @q.sorts.empty?
    @games = @q.result.page(params[:page]).per(10).order("created_at DESC")
  end
end
