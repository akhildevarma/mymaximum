class AddTaggedToTopicSearches < ActiveRecord::Migration
  def change
    add_column :topic_searches, :tagged, :boolean
  end
end
