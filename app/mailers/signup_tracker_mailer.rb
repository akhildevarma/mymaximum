class SignupTrackerMailer < ApplicationMailer
  def signup_reminder(user)
    mail(to: user.email, subject: 'What Happened?')
  end
end
