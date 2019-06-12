class RelatedInquiriesController < ApplicationController
  before_filter :require_student

  def index
    @inquiry = Inquiry.find(params[:inquiry_id]).decorate
    @related_inquiries = @inquiry.related_inquiries.decorate
  end

  def show
    @inquiry = Inquiry.find(params[:inquiry_id]).decorate
    @related_inquiry = Inquiry.find(params[:id]).decorate
  end
end
