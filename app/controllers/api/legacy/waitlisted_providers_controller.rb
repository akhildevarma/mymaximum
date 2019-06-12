class API::Legacy::WaitlistedProvidersController < ApplicationController
  skip_filter :authenticate
  respond_to :json

  def create
    @waitlisted_user = WaitlistedUser.for_provider(waitlisted_provider_params)
    if @waitlisted_user.save
      respond_to do |format|
        format.json { head :ok }
      end
    else
      respond_to do |format|
        format.json { head :bad_request }
      end
    end
  end

  private

  def waitlisted_provider_params
    params.require(:waitlisted_user).permit(:email)
  end
end
