class AddFdaResultAndFdaQueryCompleteToTopicSearches < ActiveRecord::Migration
  def change
    add_column :topic_searches, :fda_result, :json
    add_column :topic_searches, :fda_query_complete, :boolean, default: false
  end
end
