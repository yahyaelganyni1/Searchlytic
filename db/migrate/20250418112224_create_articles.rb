class CreateArticles < ActiveRecord::Migration[8.0]
  def change
    create_table :articles do |t|
      t.string :title, null: false
      t.text :content, null: false
      t.string :author
      t.string :category
      t.json :tags
      t.datetime :published_at

      t.timestamps
    end
  end
end
