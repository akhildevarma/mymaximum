class RemoveInitialSurveyResponseIdAndFollowupSurveyResponseIdFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :initial_survey_response_id, :integer
    remove_column :users, :followup_survey_response_id, :integer
  end
end
