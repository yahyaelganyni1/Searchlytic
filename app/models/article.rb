class Article < ApplicationRecord
  validates :title, presence: true, length: { maximum: 255 }
  validates :content, presence: true
  validates :author, length: { maximum: 100 }, allow_blank: true


  def self.search(query)
    if query.present?
      where("title ILIKE :query OR content ILIKE :query OR author ILIKE :query", query: "%#{query}%")
    else
      all
    end
  end
end
