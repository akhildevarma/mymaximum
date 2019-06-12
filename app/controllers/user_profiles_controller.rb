class UserProfilesController < HealthcareController
  skip_filter :license_number_needed?, only: [:edit, :update]
  before_filter :require_can_edit_user, only: [:edit, :update]
  before_filter :require_can_view_user, only: [:show]

  def show
    @user_profile = UserProfile.for(User.find(params[:id]).decorate)
  end

  def edit
    @user_profile = UserProfile.for(User.find(params[:id]).decorate)
  end

  def update
    @user_profile = UserProfile.for(User.find(params[:id]).decorate)
    if @user_profile.update(user_profile_params)
      redirect_to user_profile_path(id: @user_profile.id), notice: I18n.t('user_profiles.success')
    else
      flash.now.alert = I18n.t('errors.generic')
      render 'edit'
    end
  end

  private

  def owner?
    authenticated? && params[:id] == current_user.id.to_s
  end

  def can_edit_user?
    owner? || administrator?
  end
  helper_method :can_edit_user?

  def can_view_user?
    can_edit_user? || student?
  end

  def require_can_view_user
    respond_forbidden unless can_view_user?
  end

  def require_can_edit_user
    respond_forbidden unless can_edit_user?
  end
end
