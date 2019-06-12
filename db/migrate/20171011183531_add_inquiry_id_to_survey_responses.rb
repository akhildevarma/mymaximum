class AddInquiryIdToSurveyResponses < ActiveRecord::Migration
  def change
     add_column :survey_responses, :inquiry_id, :integer
     add_index "survey_responses", ["inquiry_id"], name: "index_survey_responses_on_inquiry_id", using: :btree
  end
end
