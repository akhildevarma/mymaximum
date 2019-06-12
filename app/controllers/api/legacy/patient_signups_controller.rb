class API::Legacy::PatientSignupsController < ApplicationController
  respond_to :json

  skip_filter :authenticate

  def create
    @patient_signup = PatientSignup.new(patient_signup_params)
    @plans = PlanDecorator.decorate_collection(Plan.patient_plans)

    if @patient_signup.save
      @patient_signup.queue_welcome_email

      respond_to do |format|
        format.json { head :created }
      end
    else
      NewRelicRemote.report(@patient_signup, params)
      respond_after_error
    end

  rescue ActiveRecord::RecordInvalid => e
    NewRelicRemote.report(e, params)
    respond_after_error
  end

  private

  def patient_signup_params
    params.require(:patient_signup)
      .permit(:accept_terms_of_service,
              invitation: [:token],
              user: [:email, :password, :password_confirmation, :promo_code],
              profile: [:first_name, :middle_name, :last_name,
                        :name_suffix, :name_title, :company,
                        :city, :state, :phone_number])
  end

  def respond_after_error
    respond_to do |format|
      format.json { render json: errors_for(@patient_signup), status: :unprocessable_entity }
    end
  end
end
