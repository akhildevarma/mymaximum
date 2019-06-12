class API::Legacy::PaymentAccountsController < ApplicationController
  respond_to :json

  before_filter :require_user

  def show
    @payment_account = current_user.payment_account.decorate
    respond_with @payment_account
  end

  def update
    @payment_account = current_user.payment_account.decorate
    @plans = PlanDecorator.decorate_collection(Plan.plans_for_user_role(current_user))
    if @payment_account.update_attributes(payment_account_params)
      respond_with @payment_account, location: edit_my_profile_path
    else
      respond_to do |format|
        format.json { render json: @payment_account, status: :unprocessable_entity }
      end
    end
  end

  private

  def payment_account_params
    params.require(:payment_account).permit(:plan_id, :stripe_card_token, :coupon_code)
  end
end
