class API::V1::User::PreferencesController < ApplicationController
  respond_to :json

  def update
    head :ok unless current_user
    @preferences = current_user.preferences || current_user.build_preferences
    @preferences.attributes = preferences_params
    if @preferences.save!
      head :ok
    else
      head :error
    end
  end

  def preferences_params
    params.require(:user_preferences).permit(:inquiry_view_default_combined)
  end
end
