class CreateSearchLogs < ActiveRecord::Migration[8.0]
  def change
    create_table :search_logs do |t|
      t.string :user_ip
      t.text :search_query

      t.timestamps
    end

    add_index :search_logs, :user_ip
    add_index :search_logs, :search_query, length: 255
  end
end
