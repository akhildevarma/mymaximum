class CustomAdmin::NewsController < CustomAdmin::ApplicationController

  before_filter :authenticate_admin
  before_filter :set_inquiry, only: [:publish, :remove]

  def index
    @published_inquiries = Inquiry.published.paginate(page: params[:published_page], per_page: 20)
    @publishable_inquiries = Inquiry.publishable.paginate(page: params[:page], per_page: 20)
  end

  def publish
    if @inquiry && @inquiry.update_attributes(inquiry_params)
      @inquiry.update_attributes(published_at: Time.now)
      Guid.create(referenceable: @inquiry)
      InquiryResponseMailer.post_to_community(@inquiry).deliver_now
      flash[:success] = 'Inquiry was successfully published!'
    elsif @inquiry.errors.present?
      flash[:error] =  'Publishable title has been taken to other inquiry.Please try again with different title.'
    end

    redirect_to unique_inquiry_url(@inquiry)
  end

  def remove
    if @inquiry
      @inquiry.update_attribute(:published_at, nil)
      @inquiry.guid.destroy if @inquiry.guid.present?
    end
    flash[:success] = 'Inquiry was successfully un-published!'
    redirect_to unique_inquiry_url(@inquiry)
  end

  private

    def inquiry_params
      params.require(:inquiry).permit(:view_everyone, :title, :question)
    end

    def set_inquiry
      @inquiry = Inquiry.where(id: params[:id]).first
    end

    def unique_inquiry_url(inquiry)
      unique_url = (inquiry.slug || inquiry.try(:guid).try(:uid))
      unique_url ? guid_url(unique_url) : inquiry_url(inquiry.id)
    end
end
