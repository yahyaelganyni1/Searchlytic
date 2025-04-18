class Article < ApplicationRecord
  validates :title, presence: true, length: { maximum: 255 }
  validates :author, length: { maximum: 100 }, allow_blank: true

  def self.search(query)
    results = if query.present?
      where("title ILIKE :query OR author ILIKE :query", query: "%#{query}%")
    else
      all
    end
    results.page(1)  # Default to first page if no page specified
  end
end
