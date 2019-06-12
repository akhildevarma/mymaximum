class RenameMedlinePlusTopicToMedlinePlusResult < ActiveRecord::Migration
  def change
    rename_column :topic_searches, :medline_plus_topic, :medline_plus_result
  end
end
