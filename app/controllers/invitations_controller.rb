class InvitationsController < CustomAdmin::ApplicationController
  before_filter :require_administrator

  def new
    @invitation = Invitation.new
  end

  def create
    @invitation = Invitation.new(invitation_params)
    if @invitation.save
      if @invitation.student?
        InvitationMailer.invite_student(current_user, @invitation).deliver_later
      else
        InvitationMailer.invite(current_user, @invitation).deliver_later
      end
      redirect_to root_url, notice: I18n.t('invitation.sent', email: @invitation.email)
    else
      flash.now.alert = I18n.t('errors.generic')
      render 'new'
    end
  end

  private

  def invitation_params
    params.require(:invitation).permit(:email, :invitation_type)
  end
end
