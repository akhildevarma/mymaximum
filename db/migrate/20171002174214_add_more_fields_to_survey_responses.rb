class AddMoreFieldsToSurveyResponses < ActiveRecord::Migration
  def change
     add_column :survey_responses, :intervention, :boolean
     add_column :survey_responses, :outcome, :text
  end
end
