class AddMeshDescriptorsToTopicSearches < ActiveRecord::Migration
  def change
    add_column :topic_searches, :mesh_descriptors, :string, array: true, default: []
  end
end
