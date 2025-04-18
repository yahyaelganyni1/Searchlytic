class SearchLogsController < ApplicationController
  # GET /search_logs
  def index
    @search_logs = SearchLog.all

    render json: @search_logs, status: :ok
  end
end
