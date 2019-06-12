class TwilioSmsResponsesController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def create
    from_number = params[:From]
    sms_body = params[:Body]
    # incoming numbers are formatted like +11234567890, so let's ignore the +1
    from_number = from_number[2..-1]
    render xml: SurveyProcessor.new(phone_number: from_number).respond(sms_body)
  end
end
