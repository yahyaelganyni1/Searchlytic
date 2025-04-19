class SearchLogsController < ApplicationController
  # before_action :set_search_log, only: [ :index, :show, :create ]
  skip_before_action :verify_authenticity_token

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
    # for now return all for test purposes
    @final_logs = SearchLog.final_queries.for_user(user_ip).recent

    render json: @final_logs, status: :ok
  end

  # POST /search_logs
  def create
    @search_log = SearchLog.log_search(
      search_log_params[:search_query],
      search_log_params[:user_ip],
      search_log_params[:session_id],
      search_log_params[:is_final_query]
    )

    if @search_log
      render json: @search_log, status: :created
    else
      render json: { error: "Failed to log search" }, status: :unprocessable_entity
    end
  end

  private

  def search_log_params
    search_params = params.require(:search_log).permit(:search_query, :is_final_query)
    search_params[:user_ip] = params[:user_ip] || request.remote_ip
    search_params[:session_id] = request.session_options[:id]
    search_params
  end
end
