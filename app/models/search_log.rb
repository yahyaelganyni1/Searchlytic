class SearchLog < ApplicationRecord
  # Validations
  validates :search_query, presence: true
  validates :user_ip, presence: true

  # Scopes
  scope :recent, -> { order(created_at: :desc) }
  scope :for_user, ->(user_ip) { where(user_ip: user_ip) }
  scope :final_queries, -> { where(is_final_query: true) }

  # Associations
  # Add any necessary associations here

  # Instance methods
  def mark_as_final_query
    update(is_final_query: true)
  end

  def increment_score
    update(score: (score || 0) + 1)
  end

  # Class methods
  def self.log_search(query, user_ip, session_id, is_final_query = false)
    # Look for an existing log with the same query and user_ip
    existing_log = where(search_query: query, user_ip: user_ip).first

    if existing_log
      # Increment the score for existing log
      existing_log.increment_score
      # Update final_query status if needed
      existing_log.update(is_final_query: true) if is_final_query
      existing_log
    else
      # Create a new log with initial score of 1
      create(
        search_query: query,
        user_ip: user_ip,
        session_id: session_id || nil,
        is_final_query: is_final_query,
        score: 1
      )
    end

  rescue => e
    Rails.logger.error("Failed to log search: #{e.message}")
    nil
  end
end
