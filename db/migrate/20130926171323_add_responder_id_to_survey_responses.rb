class AddResponderIdToSurveyResponses < ActiveRecord::Migration
  def change
    add_reference :survey_responses, :responder, index: true
  end
end
