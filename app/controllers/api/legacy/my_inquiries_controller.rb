class API::Legacy::MyInquiriesController < ApplicationController
  respond_to :json
  before_filter :require_provider


  def index
    @inquiry = Inquiry.new
    @inquiries = Inquiry.where(submitter_id: current_user.id)
                 .reverse_chronological_order
                 .decorate
    respond_with @inquiries
  end

  def create
    @inquiry = Inquiry.new(inquiry_params)
    if @inquiry.save_and_bill
      # InquirySubmissionMailer.submission_notification(@inquiry).deliver_later
      save_document if @inquiry.project_type_related? && params[:document].present?
      respond_with @inquiry, location: my_inquiries_path, serializer: V2::InquirySerializer
    else
      respond_with @inquiry, status: :unprocessable_entity
    end
  end

  def summary_tables
    @inquiry = Inquiry.closed.where(submitter_id: current_user.id).find(params[:id])
    unless @inquiry.received?
      @inquiry.mark_response_received!
      SurveyProcessor.new(user_id: @inquiry.submitter_id, inquiry_id: @inquiry.id).start_initial_survey # if it hasn't already been sent
    end
    @comment = Comment.new
    @comments =  @inquiry.comments.where({deleted: false})
    @inquiry = @inquiry.decorate
    respond_with @inquiry
  end

  private
    def save_document
      @document = Document.new(document_params)
      @document.referenceable = @inquiry
      @document.user = @inquiry.submitter
      if @document.valid?
        @document.save!
      else
        flash.notice = 'Unable to upload P&T documents'
      end
    end

  def document_params
    params.require(:document).permit(:file)
  end

  def inquiry_params
    params.require(:inquiry).permit(:question, :turnaround_time, :project_types).merge(submitter: current_user)
  end
end
