class InquirySubmissionMailer < ApplicationMailer
  def submission_notification(inquiry)
    @inquiry = inquiry
    @name = inquiry.submitter.decorate.name
    mail(to: inquiry.submitter.email, subject: I18n.t('inquiries.submission_notification_subject'))
  end

  def assignment_notification(inquiry)
    @inquiry = inquiry
    mail(to: inquiry.assignee.email, subject: I18n.t('inquiries.assignment_notification_subject'))
  end
end
