class API::Legacy::InquiryTagsController < ApplicationController
  respond_to :json
  before_filter :require_researcher, only: [:create, :destroy]
  before_filter :set_inquiry, except: :show

  def show
    respond_with Inquiry.tag_suggestions(params[:query])
  end

  def create
    @inquiry.tag_list.add(tag)
    @inquiry.save
    head :ok
  end

  def destroy
    @inquiry.tag_list.remove(tag)
    @inquiry.save
    head :ok
  end

  private

  def inquiry_tags_params
    params.permit(:inquiry_id, :tag_name)
  end

  def set_inquiry
    @inquiry = Inquiry.find(params[:inquiry_id])
  end

  def tag
    params[:tag_name].strip
  end

end
