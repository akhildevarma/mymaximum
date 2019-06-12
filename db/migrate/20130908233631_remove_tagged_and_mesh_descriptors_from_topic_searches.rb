class RemoveTaggedAndMeshDescriptorsFromTopicSearches < ActiveRecord::Migration
  def up
    remove_column :topic_searches, :tagged
    remove_column :topic_searches, :mesh_descriptors
  end

  def down
    add_column :topic_searches, :tagged, :boolean
    add_column :topic_searches, :mesh_descriptors, :string, array: true, default: []
  end
end
