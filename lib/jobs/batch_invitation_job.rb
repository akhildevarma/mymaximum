BatchInvitation = Struct.new(:number_of_invitations, :provider)
class BatchInvitationJob < BatchInvitation
  def perform
    batch_user = OpenStruct.new(email: 'no-reply@inpharmd.com')
    WaitlistedUser.where(provider: provider).next(number_of_invitations).each do |waitlisted_user|
      waitlisted_user.with_transaction_returning_status do
        invitation = Invitation.new(email: waitlisted_user.email, invitation_type: Invitation::GENERAL_INVITATION_TYPE)
        everything_ok = invitation.save && waitlisted_user.destroy
        InvitationMailer.invite(batch_user, invitation).deliver_now if everything_ok
        everything_ok
      end
    end
  end
end
