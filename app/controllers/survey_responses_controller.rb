class SurveyResponsesController < ApplicationController
  before_filter :require_administrator

  def index
    respond_to do |format|
      format.html
      format.csv { @survey_responses = SurveyResponse.all.decorate }
    end
  end
end
