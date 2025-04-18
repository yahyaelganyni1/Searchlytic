# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Set Faker locale to English (though it's often the default)
Faker::Config.locale = 'en'

# Define realistic article categories
ARTICLE_CATEGORIES = [ 'Technology', 'Science', 'Politics', 'Health', 'Business', 'Entertainment', 'Sports', 'World News', 'Lifestyle' ]

# Create 50 fake articles
100.times do
  Article.create!(
    title: Faker::Book.title,
    author: Faker::Book.author,
    category: Faker::Book.genre,
    tags: { keywords: Faker::Lorem.words(number: 3) },
    published_at: Faker::Time.between(from: 30.days.ago, to: Time.now)
  )
end

# Create 30 fake search logs
30.times do
  SearchLog.create!(
    search_query: Faker::Book.title,
    user_ip: Faker::Internet.ip_v4_address,
    is_final_query: [ true, false ].sample,
    session_id: SecureRandom.hex(10),
    created_at: Faker::Time.between(from: 14.days.ago, to: Time.now)
  )
end

puts "Created 30 search logs with realistic data"

puts "Created 50 articles with additional fields and realistic categories"
