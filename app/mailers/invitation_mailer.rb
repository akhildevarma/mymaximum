class InvitationMailer < ApplicationMailer
  def invite(inviter, invitation)
    @inviter = inviter
    @invitation = invitation
    mail(to: invitation.email, subject: I18n.t('invitation.invite_subject'), mail_type: :invitation)
  end

  def invite_student(inviter, invitation)
    @inviter = inviter
    @invitation = invitation
    mail(to: invitation.email, subject: I18n.t('invitation.invite_student_subject'), mail_type: :invitation)
  end

  def invite_reminder(invitation)
    @invitation = invitation
    @invitation_params = { token: @invitation.token } if ApplicationSettings.load.require_general_invitations
    mail(to: invitation.email, subject: I18n.t('invitation.reminder_subject'), mail_type: :invitation)
  end
end
