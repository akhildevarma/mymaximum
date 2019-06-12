# Preview all emails at http://localhost:3000/rails/mailers
class NotificationMailerPreview < ActionMailer::Preview

  def response_overdue
    inquiry = FactoryGirl.create :inquiry, :with_assignee
    assignee = inquiry.assignee.decorate
    NotificationMailer.response_overdue(assignee, inquiry)
  end

end
