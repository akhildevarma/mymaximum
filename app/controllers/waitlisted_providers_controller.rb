class WaitlistedProvidersController < CustomAdmin::ApplicationController
  skip_filter :authenticate

  def new
    @waitlisted_user = WaitlistedUser.for_provider
  end

  def create
    @waitlisted_user = WaitlistedUser.for_provider(waitlisted_provider_params)
    if @waitlisted_user.save
      flash.notice = I18n.t('waitlisted_provider.success', email: @waitlisted_user.email)

      respond_to do |format|
        format.html { redirect_to root_path }
        format.json { head :ok }
      end
    else
      flash.now.alert = I18n.t('errors.generic')

      respond_to do |format|
        format.html { render :new }
        format.json { head :bad_request }
      end
    end
  end

  private

  def waitlisted_provider_params
    params.require(:waitlisted_user).permit(:email)
  end
end
