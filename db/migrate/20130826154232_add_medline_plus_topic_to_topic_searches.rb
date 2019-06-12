class AddMedlinePlusTopicToTopicSearches < ActiveRecord::Migration
  def change
    add_column :topic_searches, :medline_plus_topic, :json
  end
end
