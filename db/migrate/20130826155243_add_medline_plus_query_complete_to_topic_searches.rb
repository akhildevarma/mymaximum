class AddMedlinePlusQueryCompleteToTopicSearches < ActiveRecord::Migration
  def change
    add_column :topic_searches, :medline_plus_query_complete, :boolean, default: false
  end
end
