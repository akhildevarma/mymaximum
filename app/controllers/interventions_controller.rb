class InterventionsController < ApplicationController
  respond_to :json

  before_filter :require_provider

  def create
    @intervention = Intervention.new(intervention_params)
    if @intervention.valid? && @intervention.save
      @intervention.inquiry.update_attribute(:intervention_response, true)
      flash.notice = I18n.t('interventions.success')
    else
      flash.now.alert = I18n.t('errors.generic')
    end
    redirect_to my_inquiries_url
  end

  private

  def intervention_params
    params.require(:intervention).permit(:inquiry_id, :taken, :response).merge(submitter: current_user)
  end
end
