class AddReferencesToStudySummaries < ActiveRecord::Migration
  def change
    add_column :study_summaries, :references, :text
  end
end
