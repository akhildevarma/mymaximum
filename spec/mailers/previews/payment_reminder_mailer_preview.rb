# Preview all emails at http://localhost:3000/rails/mailers
class PaymentReminderMailerPreview < ActionMailer::Preview

  def add_payment_reminder
    user = FactoryGirl.create :user_with_profile
    PaymentReminderMailer.add_payment_reminder(user)
  end

end
