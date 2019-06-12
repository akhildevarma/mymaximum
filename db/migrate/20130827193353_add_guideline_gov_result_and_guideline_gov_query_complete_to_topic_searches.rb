class AddGuidelineGovResultAndGuidelineGovQueryCompleteToTopicSearches < ActiveRecord::Migration
  def change
    add_column :topic_searches, :guideline_gov_result, :json
    add_column :topic_searches, :guideline_gov_query_complete, :boolean, default: false
  end
end
