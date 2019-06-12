class InquiryResponseMailer < ApplicationMailer
  require 'open-uri'
  def response_notification(inquiry)
    @inquiry = inquiry
    @name = inquiry.submitter.decorate.name
    @team = @inquiry.submitter.team
    @documents = (@inquiry.project_type_related? || @team.private_label?) ? @inquiry.documents : []
    @survey_response = SurveyResponse.new
    @layout = 'application_mailer'
    if @team
      @layout = 'private_label_mailer' if @team.private_label?
    end
    @documents.each do |doc|
      attachments["#{doc.file_file_name}"] = open("https:#{doc.file.url}").read
    end
    mail(to: inquiry.submitter.email, subject: I18n.t('inquiries.response_notification_subject')) do |format|
      format.html { render layout: @layout }
      format.text
    end
  end

  def rating_feedback(inquiry)
    @inquiry = inquiry
    @name = inquiry.submitter.decorate.name
    mail(to: inquiry.submitter.email, subject: I18n.t('inquiries.rating_feedback'))
  end

  def feedback_after_first_response(user)
    @inquiry = Inquiry.where(submitter: user).first
    mail(to: user.email, subject: I18n.t('inquiries.rating_feedback')) do |format|
      format.html { render layout: nil }
    end
  end

  def post_to_community(inquiry)
    @inquiry = inquiry
    @user = inquiry.submitter.decorate
    @name = @user.name
    mail(to: @user.email, subject: "Re: #{@inquiry.question}")
  end

  def community_activity(comment_id)
    @inquiry = Comment.find(comment_id).referenceable
    @user = @inquiry.submitter.decorate
    @name = @user.name
    mail(to: @user.email, subject: "Re: #{@inquiry.question}")
  end

  def response_turnaround_time(inquiry)
    mail(to: inquiry.assignee.email, subject: "Checking in on your Response", reply_to: 'ashish@inpharmd.com')
  end
end
