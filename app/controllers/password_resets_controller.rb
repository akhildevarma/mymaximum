class PasswordResetsController < ApplicationController
  skip_filter :authenticate

  layout 'session'

  def new
  end

  def create
    user = User.find_by_email(params[:email].downcase) if params[:email].present?
    if user.present?
      user.generate_password_reset!
      UserMailer.password_reset(user).deliver_later
    end
    respond_to do |format|
      flash[:notice] =  I18n.t('password_reset.sent', email: params[:email])
      format.html { redirect_to root_url }
      format.json { head :ok }
    end
  end

  def edit
    @user = User.find_by_password_reset_token!(params[:reset_token])
  end

  def update
    @user = User.find_by_password_reset_token!(params[:reset_token])
    if @user.password_reset_token_too_old?
      flash[:alert] =  I18n.t('password_reset.expired')
      redirect_to new_password_reset_path
    elsif @user.update_attributes(password_reset_params)
      flash[:notice] = I18n.t('password_reset.success')
      redirect_to root_url
    else
      render :edit
    end
  end

  private

  def password_reset_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
