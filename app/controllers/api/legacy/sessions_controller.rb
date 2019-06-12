class API::Legacy::SessionsController < ApplicationController
  respond_to :json
  skip_filter :authenticate
  skip_filter :update_profile_info?
  skip_filter :account_activated?

  def create
    email = (session_params[:email] || '').downcase

    user, deprecation_warning = User.for_authentication(email: email, set_deprecation_warning: true)
    if user && user.authenticate(session_params[:password])
      session[:user_id] = user.id
      respond_to do |format|
        format.json { head :ok }
      end
    else
      respond_to do |format|
        format.json { head :unauthorized }
      end
    end
  end

  def destroy
    session[:user_id] = nil
    head :ok
  end

  private

  def session_params
    params.permit(:email, :password)
  end
end
