# Preview all emails at http://localhost:3000/rails/mailers
class InquiryResponseMailerPreview < ActionMailer::Preview

  def response_notification
    inquiry = FactoryGirl.create :completed_inquiry
    InquiryResponseMailer.response_notification(inquiry)
  end

end
