class SurveyProcessor
  def initialize(user_id: nil, phone_number: nil, inquiry_id: nil)
    if user_id
      @user = User.find(user_id)
    else
      profile = Profile.where(phone_number: phone_number).first
      @user = profile.user if profile.present?
    end

    @inquiry = Inquiry.find_by_id inquiry_id

  end

  def start_initial_survey
    return false if @user.do_not_text || @user.initial_survey_response.present?
    s_response = SurveyResponse.create(initial: true, responder: @user, inquiry: @inquiry)
    send_message! I18n.t('survey_questions.thanks')
    send_message! I18n.t('survey_questions.begin')
    send_message! I18n.t('survey_questions.appropriate')
    s_response.update_workflow_state
  end
  handle_asynchronously :start_initial_survey, run_at: -> { Time.now.utc.in_time_zone('EST').tomorrow.at_noon } # previous value 2.hours.from_now

  def start_followup_survey
    return false if @user.do_not_text || @user.initial_survey_response.incomplete? || @user.followup_survey_response.present?

    SurveyResponse.create(initial: false, responder: @user, inquiry: @inquiry)
    send_message! I18n.t('survey_questions.followup')
  end
  handle_asynchronously :start_followup_survey, run_at: -> { Random.rand(3..9).months.from_now }

  def respond(sms_body)
    return unassign_student_user! if @user.present? && sms_body.upcase.include?(I18n.t('survey_questions.error_keyword'))
    return stop_texting_user! if @user.present? && sms_body.upcase.include?(I18n.t('survey_questions.stop_keyword'))
    return '' unless @user.present? && @user.open_survey_response.present?

    survey_response = @user.open_survey_response
    is_initial_response = (survey_response == @user.initial_survey_response)
    if process_user_response(survey_response, sms_body)
      response_xml = twilio_response_xml(I18n.t("survey_questions.#{survey_response.question}#{'_followup' if !is_initial_response}")) unless survey_response.question.nil?
    else
      response_xml = twilio_response_xml(I18n.t('survey_questions.error'))
    end

    if is_initial_response && survey_response.complete?
      self.start_followup_survey # ... in a few months.
    end

    if survey_response.complete? && survey_response.recommendation_likely?
      send_message! I18n.t('survey_questions.recommend')
    end

    response_xml
  end

  private

  def twilio_messages_client
    Twilio::REST::Client.new(
      ENV['TWILIO_ACCOUNT_SID'], # Rails.application.secrets.twilio_account_sid,
      ENV['TWILIO_AUTH_TOKEN'] # Rails.application.secrets.twilio_auth_token
    ).account.sms.messages
  end

  def process_user_response(survey_response, sms_body)
    survey_response.record_answer sms_body
  end

  def stop_texting_user!
    return '' unless @user.present?
    @user.do_not_text = true
    @user.save
    twilio_response_xml(I18n.t('survey_questions.stop_confirmation'))
  end

  def unassign_student_user!
    return '' unless @user.present?
    if student = @user.student
      student.update_attribute(:is_active, false)
      if inquiry = @user.assigned_inquiries.last
        inquiry.assignee =  nil
        inquiry.set_assignee
        inquiry.save
        inquiry.update_assignee
      end
    end

    twilio_response_xml(I18n.t('survey_questions.error_unassign'))
  end

  def send_message!(body)
    return false unless\
        @user.present? &&\
        @user.profile.present? &&\
        recipient_number = @user.profile.phone_number

    from = ENV['TWILIO_PHONE_NUMBER'] #Rails.application.secrets.twilio_phone_number
    to = "+1#{@user.profile.phone_number}"
    twilio_messages_client.create(
      from: from, to: to,
      body: body
    )
  end

  def twilio_response_xml(body)
    twiml = Twilio::TwiML::Response.new do |r|
      r.Sms body
    end
    twiml.text
  end
end
