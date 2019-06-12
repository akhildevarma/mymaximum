class CustomAdmin::InquiriesController < CustomAdmin::ApplicationController
  def index
    respond_to do |format|
      format.html
    end
  end
end
