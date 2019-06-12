class AccountActivationsController < ApplicationController

  before_filter :authenticated?, except: [:email_activation]
  skip_filter :account_activated?
  skip_filter :update_profile_info?


  def new
    @user = current_user.decorate
    AccountActivationMailer.account_activation(@user).deliver_now
    flash[:notice] = "Account activation email sent to #{@user.email}"
  end

  def show
    @user = User.find_by_account_activation_token(params[:token])
    if @user.try :activate_account!
      login(@user)
      original_url = session[:original_url] || '/'
      session[:original_url] = nil
      flash[:notice] = I18n.t("account.activation.success")
      redirect_to original_url
    else
      flash[:error] = I18n.t("account.activation.errors.invalid_token")
      redirect_to root_path
    end
  end

  def email_activation
    user_email = User::Email.find_by(activation_token: params[:token])
    if user_email.try :activate_email!
      flash[:notice] = I18n.t('account.activate_other_email.success')
    else
      flash[:error] = I18n.t('account.activate_other_email.errors.invalid_token')
    end
    redirect_to login_path
  end

end
