# Preview all emails at http://localhost:3000/rails/mailers
class InquirySubmissionMailerPreview < ActionMailer::Preview

  def submission_notification
    InquirySubmissionMailer.submission_notification( inquiry )
  end

  def assignment_notification
    NotificationMailer.assignment_notification( inquiry )
  end

  private
  def inquiry
    FactoryGirl.create :inquiry
  end

end
