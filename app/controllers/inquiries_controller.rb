class InquiriesController < ApplicationController
  skip_filter :authenticate, only: [:thanks_rating]
  before_filter :require_student, except: [:show, :rating, :thanks_rating,:re_open]
  before_filter :set_paper_trail_whodunnit, unless: :json_request?
  before_filter :set_referer, only: [:rating] , unless: :xhr_request?
  before_filter :set_inquiry, only: [:add_doc, :edit, :auto_save, :write_blog, :show, :update, :re_open, :rating, :thanks_rating]
  before_filter :require_provider, only: [:show, :rating, :re_open], unless: :student_or_everyone?

  def index
    @inquiries = Inquiry.open.non_blog.order_by_priority.decorate
  end

  def closed
   @inquiries = InquiryDecorator.decorate_collection(Inquiry.closed.non_blog.paginate(page: params[:page], per_page: 8).order(created_at: :desc))
  end

  def edit
  end

  def write_blog
    @inquiry ||= Inquiry.create(inquiry_type: 'blog',submitter: current_user)
  end

  def add_doc
    if @inquiry.update_attributes(inquiry_params)
      flash[:notice] =  I18n.t('inquiries.added_doc')
    else
      flash[:notice] =  I18n.t('errors.generic')
    end
    redirect_to [:edit, @inquiry]
  end

  def rating
    if score = params[:score] 
      survey = SurveyResponse.create(rating: score, overall_experience: params[:overall_experience],responder: current_user, inquiry: @inquiry, workflow_state: :complete)
      InquiryResponseMailer.rating_feedback(@inquiry).deliver_now if (survey.rating <=3 && xhr_request?)
      session[:referer_url] = nil
    end
    respond_to do |format|
      format.js { render 'shared/rating' }
      format.html { redirect_to inquiry_path(@inquiry) }
    end
  end

  def thanks_rating
    if score = params[:score]
      survey = SurveyResponse.where(responder: @inquiry.submitter, inquiry: @inquiry, workflow_state: :complete)
      if survey.present?
        session[:referer_url] = nil
        redirect_to inquiry_path(@inquiry)
      else
        survey = SurveyResponse.create(rating: score, overall_experience: params[:overall_experience],responder: @inquiry.submitter, inquiry: @inquiry, workflow_state: :complete)
        session[:referer_url] = nil
        InquiryResponseMailer.rating_feedback(@inquiry).deliver_now if (survey.rating <=3)
      end
    end
  end

  def re_open
    if @inquiry.update_attributes(reopen_params)
      flash[:notice] =  I18n.t('inquiries.reopened')
    else
      flash[:notice] =  I18n.t('errors.generic')
    end
    redirect_to inquiry_path(@inquiry)
  end

  def show
    unless admin? || student? || for_everyone? || (@inquiry.submitter == current_user) || (@inquiry.submitter.team == current_user.team)
      return redirect_to new_session_path unless authenticated?
      raise ActiveRecord::RecordNotFound
    end
  end

  def update
    renderer = :edit
    if inquiry_params[:inquiry_type].present? && inquiry_params[:inquiry_type]=='blog'
      renderer = :write_blog
    end
    if @inquiry.update_attributes(inquiry_params)
      redirect_to [renderer, @inquiry], notice: I18n.t('inquiries.updated')
    else
      flash.now.alert = I18n.t('errors.generic')
      render renderer
    end
  end

  def auto_save
    @inquiry.update_attributes(inquiry_params)
    respond_to do |format|
      format.json { render json:  { ok: I18n.t('inquiries.autosave') }}
    end
  end

  def level_of_evidence
    @evidence = LevelOfEvidence.where(treatment: params[:treatment]).map(&:medicine.to_proc).uniq
    respond_to do |format|
      format.js
    end
  end

  def review 
    @inquiry = Inquiry.open.find(params[:id]).decorate
    if @inquiry.title.blank? && @inquiry.inquiry_type=='blog'
       redirect_to [:write_blog, @inquiry], notice: 'Publishable Title is a required field to review/publish a blog'
    end
  end

  def send_response
    @inquiry = Inquiry.open.find(params[:id]).decorate
    @inquiry.send_response!
    if @inquiry.inquiry_type!='blog'
      update_documents_status if @inquiry.project_type_related?
      InquiryResponseMailer.response_notification(@inquiry).deliver_later rescue nil
      Notification.send_response_text(@inquiry) rescue nil
      redirect_to inquiries_path, notice: I18n.t('inquiries.response_sent')
    else
      @inquiry.update_attributes(published_at: Time.now, view_everyone: true)
      redirect_to news_path, notice: I18n.t('inquiries.response_sent')
    end
  end

  private

  def inquiry_params
    params.require(:inquiry).permit(
      :status, :tag_list,
      :custom_response_text, :background, :background_references,
      :relevant_prescribing_info,
      :relevant_prescribing_info_references,
      :researchable_question, :search_strategy,:dropbox_urls,
      :review_of_clinical_guidelines,
      :review_of_meta_analyses,
      :review_of_review_articles,
      :review_of_other_tertiary_literature,
      :title,
      :inquiry_type,
      :project_types,
      :hidden_sections,
      :doc_url,
      :level_of_evidence
      )
  end

  def reopen_params
    {turnaround_time: :not_urgent, reopened_at: DateTime.now.utc, status: :response_formulation, hidden_sections: {summary_tables: false}}
  end

  def set_inquiry
    @enable_discussion = false
    if params[:id].present?
      @inquiry = Inquiry.find(params[:id]).decorate
    elsif params[:guid].present? && guid = (Inquiry.where(slug: params[:guid].downcase).first || Guid.where(uid: params[:guid]).first)
      @inquiry = guid.class.name == 'Inquiry' ? guid.decorate : guid.referenceable.decorate
      @enable_discussion = true
    end
  end

  def update_documents_status
    if @inquiry.documents.present?
      @inquiry.documents.update_all(status: :complete)
    end
  end

  def for_everyone?
    @inquiry && @inquiry.view_everyone?
  end

  def student_or_everyone?
    student? || for_everyone?
  end

  def set_layout
    @layout = case action_name
      when "show"
        "healthcare"
      else
         "research"
      end
  end

  def set_referer
    session[:referer_url] = request.url
    logger.info "session[:referer_url]::#{session[:referer_url]}"
  end

end
