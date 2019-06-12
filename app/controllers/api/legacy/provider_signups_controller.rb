class API::Legacy::ProviderSignupsController < ApplicationController
  respond_to :json

  skip_filter :authenticate
  before_filter :force_logout

  def create
    @provider_signup = ProviderSignup.new(provider_signup_params)
    @plans = PlanDecorator.decorate_collection(Plan.provider_plans)

    @provider_signup.provider.skip_specialty_validation = request.format.json?
    if @provider_signup.save
      @provider_signup.queue_welcome_email

      respond_to do |format|
        format.json { head :created }
      end
    else
      NewRelicRemote.report(@provider_signup,
        request_params: params,
        custom_params: {
          error_messages_json: @provider_signup.json_errors.to_json
        }
      )
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
              payment_account: [:plan_id, :stripe_card_token, :last_four_digits])
  end

  def respond_after_error
    respond_to do |format|
      format.json { render json: errors_for(@provider_signup), status: :unprocessable_entity }
    end
  end
end
