
class Users::TeamSignupsController < ApplicationController
  before_filter :set_signup_url_path
  before_filter :check_team_path, only: [:new]
  before_filter :set_team_signup
  before_filter :logout


  def new
  end

  def add
    if params[:token] && (@user = User.where({account_activation_token: params[:token]}).first) && (@user.requires_account_activation?)
      session[:original_email] = @user.email
      @team = @user.team if @user.private_labeled_user?
    else
      flash[:notice] = 'This account is already activated.'
      redirect_to login_path
    end
  end

  def create
    non_bulk_uploaded_user &&\
    valid_team_email_submitted? &&\
    final_signup_submission? &&\
    signup_success?
  end

  def edit
    update_signup?
  end

  def set_team_signup
    params[:user_team_signup] = (params[:user_team_signup] || {}).merge(signup_url_path: signup_url_path)
    @team_signup ||= User::TeamSignup.new(safe_params)
  end

  class SafeParams
    def self.build params
      begin
        params
          .require(:user_team_signup)
          .permit(
            {
              user: [:email, :password, :password_confirmation]
            },
            :email_username,
            :token,
            :accept_team_of_service_and_privacy_policy,
            :signup_url_path
          )
      rescue
        {}
      end
    end
  end
  def safe_params; SafeParams.build(params); end

  def logout
    session[:user_id] = nil
  end

  private

  def check_team_path
    team = Team.find_by_signup_url_path(signup_url_path)
    if team.blank?
      raise ::ActionController::RoutingError.new('Not Found')
    elsif team.private_label?
      session[:team_name] = signup_url_path
      redirect_to root_path and return
    end
  end

  def non_bulk_uploaded_user
    if (user = User.find_by(email: @team_signup.email)) && user.requires_account_activation?
       url = add_team_user_signups_url(signup_url_path: (user.team.try :signup_url_path) , token: user.account_activation_token)
       redirect_to url and return
    else
      true
    end
  end

  def valid_team_email_submitted?
    if (@team_signup.email? && @team_signup.valid?)
      true
    elsif @team_signup.email_taken?
      render_email_taken
    else
      render_invalid_email
    end
  end

  def same_email?
    safe_params[:user][:email] == session[:original_email]
  end

  def render_invalid_email
    flash.now[:error] = I18n.t('signup.team_provider.invalid')
    render 'new'
    false
  end

  def render_email_taken
    flash.now[:error] = I18n.t('signup.team_provider.email_taken')
    render 'new'
    false
  end

  def final_signup_submission?
    (!!safe_params[:user]) ? true : (render 'create'; false)
  end

  def update_signup?
    if !session[:original_email].blank? && (@user = User.where({email: session[:original_email]}).first)
      valid_user_params? && proceed_signup
    end
  end

  def valid_user_params?
    @user = @team_signup.validate_user_params(safe_params[:user],@user)
    if validate_service_privacy? || @user.errors.any? 
      params[:email] = safe_params[:user][:email]
      render 'add' and return
    else
      true
    end
  end

  def proceed_signup
    @team_signup.update(@user, safe_params)
    flash.notice = I18n.t('signup.team_provider.success')
    flash[:first_login] = true
    session[:user_id] = @user.id
    session[:team_name] = safe_params[:signup_url_path] if @user.private_labeled_user?
    redirect_to root_path  
  end

  def validate_service_privacy?
    if @team_signup.accept_team_of_service_and_privacy_policy != '1'
      @team_signup.errors[:accept_team_of_service_and_privacy_policy] << 'must accept terms of use'
      flash.now[:error] = 'Please accept terms of use'
    end    
  end

  def signup_success?
    if @team_signup.save
       SignupMailer.welcome(@team_signup.user).deliver_now
      flash.notice = I18n.t('signup.team_provider.success')
      flash[:first_login] = true
      session[:user_id] = @team_signup.user.id
      session[:team_name] = params[:signup_url_path] if @team_signup.team.private_label?
      redirect_to root_path
    end
  end

  def signup_url_path
    @signup_url_path ||= ( params[:signup_url_path].downcase! || params[:signup_url_path] )
  end
  alias_method :set_signup_url_path, :signup_url_path

end
