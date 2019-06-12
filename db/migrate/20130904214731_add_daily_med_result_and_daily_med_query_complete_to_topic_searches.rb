class AddDailyMedResultAndDailyMedQueryCompleteToTopicSearches < ActiveRecord::Migration
  def change
    add_column :topic_searches, :daily_med_result, :json
    add_column :topic_searches, :daily_med_query_complete, :boolean, default: false
  end
end
