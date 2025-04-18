class ArticlesController < ApplicationController
  def index
    query = params[:query].to_s.strip
    @page = params[:page] || 1
    @per_page = params[:per_page] || 10

    @articles = if query.present?
                  Article.search(query).page(@page).per(@per_page)
    else
                  Article.page(@page).per(@per_page)
    end

    # Log the search query if one was provided
    log_search(query) if query.present?
  end

  private

  def log_search(query)
    SearchLog.create(
      search_query: query,
      user_ip: request.remote_ip
    )
  rescue => e
    # Just log the error and continue - don't disrupt the user experience
    Rails.logger.error("Failed to log search: #{e.message}")
  end
end
