class API::Legacy::WaitlistedPatientsController < ApplicationController
  respond_to :json
  skip_filter :authenticate

  def create
    @waitlisted_user = WaitlistedUser.for_patient(waitlisted_patient_params)
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

  def waitlisted_patient_params
    params.require(:waitlisted_user).permit(:email)
  end
end
