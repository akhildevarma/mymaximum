class AddSentFeedbackAtToSurveyresponse < ActiveRecord::Migration
  def change
    add_column :survey_responses, :sent_feedback_at, :datetime, null: true
    add_index "survey_responses", ['created_at', 'initial', 'inquiry_id', 'workflow_state', 'sent_feedback_at'], name: "index_survey_responses_on_feedback_first", using: :btree
  end
end
