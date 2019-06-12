class BlogImagesController < ApplicationController

  before_filter :require_user
  before_filter :resource, only: [:uploader]
  
  def destroy
    @image = BlogImage.find_by(id: params[:id])
    @image.image.clear
    @image.destroy
    flash[:notice] = I18n.t('images.deleted')
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
    @image = BlogImage.new(upload_params)
    @image.referenceable = resource
    @image.user = current_user
    if @image.valid? 
      @image.save!
      @errors = []
    else
      @errors = @image.errors
    end

    respond_to do |format|
      format.js
      format.html { redirect_to [:write_blog, resource] , notice: 'Successfully uploaded images.' }
    end
  end

  private
   # resource_type is type of model object like inquiry/user/team
   # resource_id  id of model object
   def resource
     @resource_type ||= params[:resource_type]
     @resource ||= @resource_type.capitalize.constantize.find_by_id params[:resource_id] rescue nil
   end

   def upload_params
     params.require(:blog_image).permit(:image,:user_id,:referenceable_id,:referenceable_type)
   end

end
