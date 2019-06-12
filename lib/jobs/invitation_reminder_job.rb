class InvitationReminderJob < Struct.new(:invitation_id)
  def perform
    invitation = Invitation.find(invitation_id)
    unless User.find_by_email(invitation.email).present?
      InvitationMailer.invite_reminder(invitation).deliver_later
    end
  rescue ActiveRecord::RecordNotFound => e
    Rails.logger.debug "Invitation with id #{invitation_id} does not exist."

    NewRelicRemote.report(e)
  end
end
