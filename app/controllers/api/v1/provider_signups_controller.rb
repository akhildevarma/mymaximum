class API::V1::ProviderSignupsController < ApplicationController
  respond_to :json

  skip_filter :authenticate

  def create
    @provider_signup = ProviderSignup.new(provider_signup_params)
    if @provider_signup.save
      @provider_signup.queue_welcome_email
      respond_with @provider_signup, status: :created
    else
      NewRelicRemote.report(@provider_signup, params)
      respond_after_error
    end
  rescue ActiveRecord::RecordInvalid => e
    NewRelicRemote.report(e, params)
    respond_after_error
  end

  private

  def provider_signup_params
    params.require(:provider_signup)
      .permit(:accept_terms_of_service,
              invitation:      [:token],
              user:            [:email, :password, :password_confirmation, :promo_code, :team_id],
              provider:        [:license_number, :licensing_state,
                                :specialty],
              profile:         [:first_name, :middle_name, :last_name,
                                :name_suffix, :name_title, :company,
                                :city, :state, :phone_number],
              payment_account: [:plan_id, :stripe_card_token, :last_four_digits, :coupon_code])
  end

  def respond_after_error
    render json: errors_for(@provider_signup), status: :unprocessable_entity
  end
end
