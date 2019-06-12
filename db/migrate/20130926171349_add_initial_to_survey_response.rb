class AddInitialToSurveyResponse < ActiveRecord::Migration
  def change
    add_column :survey_responses, :initial, :boolean
  end
end
