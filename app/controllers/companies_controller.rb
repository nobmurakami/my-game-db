class CompaniesController < ApplicationController
  def show
    @company = Company.find(params[:id])
    @q = @company.games.ransack(params[:q])
    @q.sorts = "metascore DESC" if @q.sorts.empty?
    @games = @q.result(distinct: true).page(params[:page]).per(10).order("created_at DESC")
    @companies = Company.joins(:game_companies).group(:company_id).order("count(game_id) desc").limit(20)
  end
end
