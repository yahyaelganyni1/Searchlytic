class AddScoreToSearchLogs < ActiveRecord::Migration[8.0]
  def change
    add_column :search_logs, :score, :integer
  end
end
