class RenameStudySummariesToSummaryTables < ActiveRecord::Migration
  def change
    rename_table :study_summaries, :summary_tables
  end
end
