class CustomAdmin::UsersController < CustomAdmin::ApplicationController
  before_filter :set_resource

  def index
    @users = UserDecorator.decorate_collection(User.search(params[:search]).paginate(:page => params[:page], :per_page => 20))
    respond_to do |format|
      format.html
    end
  end

  def show
    @user = UserDecorator.decorate(User.find(params[:id]))
  end

  def destroy
    UserRemover.run(destroy_params[:id])
    redirect_to admin_users_path
  end

  private

  def destroy_params
    params.permit(:id)
  end

  def set_resource
    @resource = ( params[:filter] == 'non-team' ) ? User.not_in_team : User.all.order(created_at: :desc)
  end
end
 
