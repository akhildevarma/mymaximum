class InquiryCopiesController < ApplicationController
  def create
    @source_inquiry = Inquiry.find(params[:source_inquiry_id])
    @destination_inquiry = Inquiry.find(params[:destination_inquiry_id])
    @destination_inquiry.copy_response_from(@source_inquiry)
    redirect_to [:edit, @destination_inquiry], notice: I18n.t('inquiry_copies.success')
  end
end
