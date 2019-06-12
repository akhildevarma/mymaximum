class ProviderSignupsController < ApplicationController
  respond_to :html

  skip_filter :authenticate
  before_filter :force_logout

  def new
    @provider_signup = ProviderSignup.new(new_provider_signup_params)
    @user_in_team = !new_provider_signup_params[:user].try(:[], :team_id).blank?
  end

  def team
    @available_teams = Team.order(launch_date: :asc).all.where(private_label: false)
  end

  def sign_up_tracker
    signup_track = SignupTracker.create(email: params[:email], status: true, notified_count: 0)
    signup_track.save(validate: false)
    redirect_to root_path
  end

  def create
    @provider_signup = ProviderSignup.new(provider_signup_params)
    @plans = PlanDecorator.decorate_collection(Plan.provider_plans)

    @provider_signup.provider.skip_specialty_validation = request.format.json?
    if @provider_signup.save
      flash.notice = I18n.t('signup.provider.success')
      @provider_signup.queue_welcome_email
      signup_tracker = SignupTracker.where(email: provider_signup_params[:user][:email]).first
      signup_tracker.update_attributes(status: false)
      respond_to do |format|
        format.html do
          session[:user_id] = @provider_signup.user.id
          redirect_to root_path
        end
      end
    else
      NewRelicRemote.report(@provider_signup,
        request_params: params,
        custom_params: {
          error_messages_json: @provider_signup.json_errors.to_json
        }
      )
      flash.now.notice = I18n.t('signup.provider.inactive_account') unless user = User.where(email: @provider_signup.user.email).first and user.is_active?
      respond_after_error
    end
  rescue ActiveRecord::RecordInvalid => e
    NewRelicRemote.report(e, params)
    respond_after_error
  end

  private

  def new_provider_signup_params
    params
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
    flash.now.alert = I18n.t('signup.error')
    respond_to do |format|
      format.html { render :new }
    end
  end
end
