class API::Legacy::PasswordResetsController < ApplicationController
  respond_to :json
  skip_filter :authenticate

  def create
    user = User.find_by_email(params[:email].downcase) if params[:email].present?
    if user.present?
      user.generate_password_reset!
      UserMailer.password_reset(user).deliver_later
    end
    respond_to do |format|
      format.json { head :ok }
    end
  end

  private

  def password_reset_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
