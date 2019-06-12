class NotificationMailer < ApplicationMailer

  def response_overdue(inquiry)
    @responsible_person = inquiry.assignee.try :decorate
    @question = inquiry.question
    mail to: @responsible_person.email,
      subject: I18n.t('mailer.notification.response_overdue.subject'),
      reply_to: 'advani_aa@mercer.edu'
  end

end
