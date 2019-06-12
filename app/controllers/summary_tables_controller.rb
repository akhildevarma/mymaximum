class SummaryTablesController < ResearchController
  before_filter :require_student

  def new
    @inquiry = Inquiry.find(params[:inquiry_id]).decorate
    @summary_table = SummaryTable.new.decorate
  end

  def create
    @inquiry = Inquiry.find(params[:inquiry_id]).decorate
    @summary_table = SummaryTable.new(summary_table_params.merge(inquiry_id: @inquiry.id, responder_id: current_user.id))
    renderer = :edit
    if @inquiry.inquiry_type.present? && @inquiry.inquiry_type=='blog'
      renderer = :write_blog
    end

    if @summary_table.save
      redirect_to [renderer, @inquiry], notice: I18n.t('summary_tables.created')
    else
      flash.now.alert = I18n.t('errors.generic')
      render 'new'
    end
  end

  def edit
    @inquiry = Inquiry.find(params[:inquiry_id])
    @summary_table = SummaryTable.find(params[:id]).decorate
  end

  def update
    @inquiry = Inquiry.find(params[:inquiry_id])
    @summary_table = SummaryTable.find(params[:id])
    renderer = :edit
    if @inquiry.inquiry_type.present? && @inquiry.inquiry_type=='blog'
      renderer = :write_blog
    end
    if @summary_table.update_attributes(summary_table_params)
      redirect_to [renderer, @inquiry], notice: I18n.t('summary_tables.updated')
    else
      flash.now.alert = I18n.t('errors.generic')
      render 'edit'
    end
  end

  def auto_save
    @inquiry = Inquiry.find(params[:inquiry_id]).decorate 
    @summary_table = SummaryTable.find_by_id(params[:id])
    
    if @summary_table.present?
      @summary_table.update_attributes(summary_table_params)
    else
      @summary_table = SummaryTable.create(summary_table_params.merge(inquiry_id: @inquiry.id, responder_id: current_user.id))
    end
    
    respond_to do |format|
      format.json { render json:  { ok: I18n.t('summary_tables.updated'), url: summary_tables_auto_save_path(inquiry_id: @inquiry.id, id: @summary_table.id) }}
    end
  end


  def destroy
    @inquiry = Inquiry.find(params[:inquiry_id])
    @summary_table = SummaryTable.find(params[:id])
    @summary_table.destroy
    renderer = :edit
    if @inquiry.inquiry_type.present? && @inquiry.inquiry_type=='blog'
      renderer = :write_blog
    end
    redirect_to [renderer, @inquiry], notice: I18n.t('summary_tables.deleted')
  end

  def template
    send_file Rails.root.join('static', 'table.template.docx'), type: 'application/msword'
  end

  private

  def summary_table_params
    params.require(:summary_table)
      .permit(:body_html, :references,
              :notes, :complete, :dropbox_url)
  end
end
