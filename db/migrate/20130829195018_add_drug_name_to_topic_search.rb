class AddDrugNameToTopicSearch < ActiveRecord::Migration
  def change
    add_column :topic_searches, :drug_name, :string
  end
end
