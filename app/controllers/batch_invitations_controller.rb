class BatchInvitationsController < CustomAdmin::ApplicationController
  before_filter :require_administrator

  def new
    @waitlisted_providers_count = WaitlistedUser.providers.count
    @waitlisted_patients_count = WaitlistedUser.patients.count
  end

  def create
    provider = (params[:user_role] == '1')
    Delayed::Job.enqueue BatchInvitationJob.new(params[:number_of_invitations], provider)
    redirect_to root_url, notice: I18n.t('batch_invitation.started', number: params[:number_of_invitations])
  end
end
