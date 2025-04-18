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

  # Class methods
  def self.log_search(query, user_ip, session_id = nil)
    create(search_query: query, user_ip: user_ip, session_id: session_id)
  rescue => e
    Rails.logger.error("Failed to log search: #{e.message}")
    nil
  end
end
