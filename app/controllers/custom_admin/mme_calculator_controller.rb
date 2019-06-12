class CustomAdmin::MmeCalculatorController < CustomAdmin::ApplicationController
  before_filter :require_user
  skip_before_filter :authenticate_admin

  def index
    @options = OPIOIDS
  end
end
