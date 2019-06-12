class PaymentReminderMailer < ApplicationMailer
  def add_payment_reminder(user)
    @user = user
    mail(to: user.email, subject: I18n.t('users.trial_ended_subject'))
  end
end
