class InquiryAssignmentsController < ResearchController
  before_filter :require_student

  def create
    @inquiry = Inquiry.open.find(params[:inquiry_id])
    @inquiry.assignee_id = params[:assignee_id] || current_user.id
    if @inquiry.save
      redirect_to [:edit, @inquiry], notice: I18n.t('inquiries.updated')
    else
      flash.now.alert = I18n.t('errors.generic')
      render 'inquiries/edit'
    end
  end

  def destroy
    @inquiry = Inquiry.open.find(params[:inquiry_id])
    @inquiry.assignee = nil
    if @inquiry.save
      redirect_to [:edit, @inquiry], notice: I18n.t('inquiries.updated')
    else
      flash.now.alert = I18n.t('errors.generic')
      render 'inquiries/edit'
    end
  end
end
