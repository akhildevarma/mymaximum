class AddSurveyResponsesToUsers < ActiveRecord::Migration
  def change
    add_reference :users, :initial_survey_response, index: true
    add_reference :users, :followup_survey_response, index: true
  end
end
