class API::Legacy::ApplicationSettingsController < ApplicationController
  before_filter :get_app_settings
  skip_before_filter :authenticate, only: [:show]
  respond_to :json

  def show
    respond_with @application_settings
  end

  private

  def get_app_settings
    @application_settings = ApplicationSettings.load
  end

  def application_settings_params
    params.require(:application_settings).permit(:require_general_invitations, :allow_promo_code)
  end
end
