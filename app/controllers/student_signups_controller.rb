class StudentSignupsController < ApplicationController
  def new
    @student_signup = StudentSignup.new(invitation_params)
  end

  def create
    @student_signup = StudentSignup.new(student_signup_params)
    if @student_signup.save
      redirect_to login_url, notice: I18n.t('signup.student.success')
    else
      flash.now.alert = I18n.t('signup.error')
      NewRelicRemote.report(@student_signup, params)
      render 'new'
    end
  end

  private

  def invitation_params
    params.permit(:token, :email)
  end

  def student_signup_params
    params.require(:student_signup)
      .permit(:accept_terms_of_service,
              invitation: [:token], 
              user: [:email, :password, :password_confirmation])
  end
end
