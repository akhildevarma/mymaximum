class AddOverallExperienceToSurvey < ActiveRecord::Migration
  def change
    add_column :survey_responses, :overall_experience, :text
  end
end
