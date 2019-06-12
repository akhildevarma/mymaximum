class RemoveUserIdAndInquiryIdFromSurveyResponse < ActiveRecord::Migration
  def up
    remove_column :survey_responses, :user_id
    remove_column :survey_responses, :inquiry_id
  end

  def down
    add_column :survey_responses, :user, :references
    add_column :survey_responses, :inquiry, :references
  end
end
