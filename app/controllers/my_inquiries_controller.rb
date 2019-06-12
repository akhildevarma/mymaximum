class MyInquiriesController < HealthcareController
  respond_to :json, :html

  before_filter :require_provider
  before_filter :credit_card_needs_update?, only: [:new, :create], unless: :json_request?
def index
    @inquiry = Inquiry.new
    @inquiries = current_user.submitted_inquiries.\
      order(status: :asc, created_at: :asc).\
      decorate.reverse
    respond_with @inquiries, each_serializer: MyInquirySerializer
  end

  def new
    @inquiry = Inquiry.new
  end

  def create
    @inquiry = Inquiry.new(inquiry_params)
    if @inquiry.save_and_bill
      # InquirySubmissionMailer.submission_notification(@inquiry).deliver_later
      save_document if @inquiry.project_type_related? && params[:document].present?
      flash.notice = I18n.t('inquiries.success')
      respond_with @inquiry, location: root_path(anchor: "inquiry-id-#{@inquiry.id}"), serializer: MyInquirySerializer
      #redirect_to '/'
    else
      flash.now.alert = I18n.t('errors.generic')
      respond_with @inquiry, status: :unprocessable_entity, serializer: MyInquirySerializer
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
    @document.user = current_user
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
    params.require(:inquiry).permit(:question, :turnaround_time, :project_types, :project_type_desc).merge(submitter: current_user)
  end
end
