class CreateTopicSearches < ActiveRecord::Migration
  def change
    create_table :topic_searches do |t|
      t.text :search_terms
      t.references :submitter, index: true

      t.timestamps
    end
  end
end
