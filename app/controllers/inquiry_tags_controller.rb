class InquiryTagsController < ApplicationController
  respond_to :json
  def index
    respond_with Inquiry.tag_suggestions(params[:query])
  end
end
