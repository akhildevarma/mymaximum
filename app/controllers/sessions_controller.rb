class SessionsController < ApplicationController
  skip_filter :authenticate, except: [:new]
  skip_filter :set_referer, only: [:destroy]
  skip_filter :update_profile_info?
  skip_filter :account_activated?

  before_filter :set_team , only: [:new]

  def new
    redirect_to root_path if authenticated?
  end

  def create
    email = (session_params[:email] || '').downcase

    user, deprecation_warning = User.for_authentication(email: email, set_deprecation_warning: true)
    flash[:alert] = I18n.t("sessions.deprecation_warning", email: user.email) if deprecation_warning
    if user && user.authenticate(session_params[:password])
      session[:user_id] = user.id
      session[:team_name] = nil
      if user.private_labeled_user?
        session[:team_name] = user.team.signup_url_path
        session[:referer_url] = nil
      end 
      if params[:remember_me]
        generate_remember_me_token
        cookies.permanent[:remember_me_token] = session[:remember_me_token]
      else
        cookies[:remember_me_token] = user.remember_me_token
      end
      user.update_attribute(:is_active, true) unless user.is_active?
      user.priority_student!
      respond_to do |format|
        format.html { redirect_to_referer notice: I18n.t('sessions.success') }
        format.json { head :ok }
      end
    else
      flash.now.alert = I18n.t('sessions.error')
      respond_to do |format|
        format.html { render action: 'new' }
        format.json { head :unauthorized }
      end
    end
  end

  def destroy
    user = User.where(session[:email]).first
    user.remember_me_token =nil
    user.save!
    session[:user_id] = nil
    session[:referer_url] = nil
    session[:team_name] = nil
    cookies.delete :auth_token
    cookies.delete :remember_me_token
    redirect_to root_path, notice: I18n.t('sessions.destroy')
  end

  def generate_remember_me_token
    user = User.find(session[:user_id])
    user.remember_me_token = SecureRandom.urlsafe_base64
    user.save!
    session[:remember_me_token] = user.remember_me_token
  end

  private

  def session_params
    params.permit(:email, :password)
  end

  def set_team
    if session[:team_name].present?
      @team = Team.find_by_signup_url_path(session[:team_name])
    end
  end
end
