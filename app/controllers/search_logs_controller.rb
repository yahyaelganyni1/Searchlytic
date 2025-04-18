class SearchLogsController < ApplicationController
  # before_action :set_search_log, only: [ :index, :show, :create ]

  # GET /search_logs/search
  def search
    query = params[:query].to_s.strip
    @page = params[:page] || 1
    @per_page = params[:per_page] || 10

    if query.present?
      @search_logs = SearchLog.where("search_query LIKE ?", "%#{query}%")
                              .page(@page).per(@per_page)
    else
      @search_logs = SearchLog.page(@page).per(@per_page)
    end

    render json: @search_logs, status: :ok
  end
  # GET /search_logs
  def index
    @search_logs = SearchLog.all

    render json: @search_logs, status: :ok
  end

  # GET /search_logs/:id
  def show
    @search_log = SearchLog.find(params[:id])

    render json: @search_log, status: :ok
  end

  # GET /search_logs/final_logs
  def final_logs
    user_ip = params[:user_ip] || request.remote_ip
    @final_logs = SearchLog.for_user(user_ip).final_queries.recent

    render json: @final_logs, status: :ok
  end

  # POST /search_logs
  def create
    @search_log = SearchLog.log_search(
      params[:search_query],
      request.remote_ip,
      params[:session_id]
    )
    if @search_log.persisted?
      render json: @search_log, status: :created
    else
      render json: { error: "Failed to log search" }, status: :unprocessable_entity
    end
  end
end
