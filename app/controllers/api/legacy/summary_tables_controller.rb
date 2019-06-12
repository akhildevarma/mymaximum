class API::Legacy::SummaryTablesController < ApplicationController
  before_filter :require_student

  def new
    @inquiry = Inquiry.find(params[:inquiry_id]).decorate
    @summary_table = SummaryTable.new.decorate
  end

  def create
    @inquiry = Inquiry.find(params[:inquiry_id]).decorate
    @summary_table = SummaryTable.new(summary_table_params.merge(inquiry_id: @inquiry.id, responder_id: current_user.id))
    if @summary_table.save
      redirect_to [:edit, @inquiry], notice: I18n.t('summary_tables.created')
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
    if @summary_table.update_attributes(summary_table_params)
      redirect_to [:edit, @inquiry], notice: I18n.t('summary_tables.updated')
    else
      flash.now.alert = I18n.t('errors.generic')
      render 'edit'
    end
  end

  def destroy
    @inquiry = Inquiry.find(params[:inquiry_id])
    @summary_table = SummaryTable.find(params[:id])
    @summary_table.destroy
    redirect_to [:edit, @inquiry], notice: I18n.t('summary_tables.deleted')
  end

  def template
    send_file Rails.root.join('static', 'inpharmd_table_template.doc'), type: 'application/msword'
  end

  private

  def summary_table_params
    params.require(:summary_table)
      .permit(:body_html, :references, 
              :notes, :complete, :dropbox_url)
  end
end
