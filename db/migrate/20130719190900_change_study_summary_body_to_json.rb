class ChangeStudySummaryBodyToJson < ActiveRecord::Migration
  def up
    remove_column :study_summaries, :body
    add_column :study_summaries, :body, :json
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
