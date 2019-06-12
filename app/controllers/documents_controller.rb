class DocumentsController < ApplicationController
  before_filter :set_referer, only: [:download]
  before_filter :require_user
  before_filter :documents, only: [ :show ]
  before_filter :resource, only: [:uploader]
  
  def destroy
    @document = Document.find_by(id: params[:id])
    @document.file.clear
    @document.destroy
    flash[:notice] = I18n.t('documents.deleted')
    redirect_to(:back) 
  end

  def show
    respond_to do |format|
      format.js
    end
  end

  def uploader
    respond_to do |format|
      format.js
    end
  end

  def upload
    @document = Document.new(upload_params)
    @document.referenceable = resource
    @document.user = current_user
    if @document.valid? 
      @document.save!
      @errors = []
    else
      @errors = @document.errors
    end

    respond_to do |format|
      format.js
      format.html { redirect_to :back, notice: 'Successfully uploaded documents.' }
    end
  end

  def download
    document = Document.find_by(token: params[:token])
    if document.present? && document.file.present?
      session[:referer_url] = nil
      redirect_to document.file.expiring_url(10)
    else
      redirect_to :back, notice: I18n.t('documents.unavailable')
    end
  end


  private
   # resource_type is type of model object like inquiry/user/team
   # resource_id  id of model object
   def resource
     @resource_type ||= params[:resource_type]
     @resource ||= @resource_type.capitalize.constantize.find_by_id params[:resource_id] rescue nil
   end

   def documents
     @documents ||= resource.documents
   end

   def upload_params
     params.require(:document).permit(:file,:user_id,:description,:status,:referenceable_id,:referenceable_type)
   end

    def set_referer
      if request.format == "text/html" || request.content_type == "text/html"
        session[:referer_url] = request.fullpath
      end
    end

end
