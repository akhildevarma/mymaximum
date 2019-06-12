class ApplicationSettingsController < ApplicationController
  skip_before_filter :authenticate, only: [:show]
  before_filter :require_administrator, except: [:show]
  before_filter :get_app_settings
  respond_to :html

  def show
    respond_with @application_settings
  end

  def edit
    respond_with @application_settings
  end

  def update
    if @application_settings.update_attributes(application_settings_params)
      flash.notice = I18n.t('application_settings.success')
    else
      flash.now.alert = I18n.t('errors.generic')
    end

    respond_with @application_settings, location: edit_application_settings_path
  end

  private

  def get_app_settings
    @application_settings = ApplicationSettings.load
  end

  def application_settings_params
    params.require(:application_settings).permit(:require_general_invitations, :allow_promo_code)
  end
end
