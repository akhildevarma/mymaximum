class ProviderPlansController < ApplicationController
  skip_filter :authenticate

  respond_to :json

  def index
    @plans = Plan.provider_plans
    respond_with @plans
  end
end
