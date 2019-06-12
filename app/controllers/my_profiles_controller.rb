class MyProfilesController < HealthcareController
  respond_to :html

  before_filter :require_user
  skip_filter :require_can_edit_user
  skip_filter :require_can_view_user
  skip_filter :update_profile_info?

  def edit
    @user_profile = UserProfile.for(current_user.decorate)
  end

  def deactivate
    current_user.update_attribute(:is_active, false)
    session[:user_id] = nil
    cookies.delete :auth_token
    redirect_to login_url
  end

  def update
    @user_profile = UserProfile.for(current_user.decorate)
    if @user_profile.update(user_profile_params)
      flash.notice = I18n.t('user_profiles.success')
      original_redirect_url = (session[:original_url] || root_path)
      session[:original_url] = nil
      respond_with @user_profile, location: original_redirect_url
    else
      NewRelicRemote.report(@user_profile, params)
      respond_after_error
    end
  rescue ActiveRecord::RecordInvalid => e
    NewRelicRemote.report(e, params)
    respond_after_error
  end

  # To Join discussion
  def join_discussion
    @user_profile = UserProfile.for(current_user.decorate)
    profile = Profile.new(user_profile_params[:profile].merge(user: current_user))
    if profile.valid?
      @user_profile.update(user_profile_params)
      @errors = []
    else
      @errors = profile.errors
    end

    respond_to do |format|
      format.js { render 'comments/join_discussion' }
    end
  end

  def respond_after_error
    flash.now.alert = I18n.t('errors.generic')
    respond_to do |format|
      format.html { render :edit }
    end
  end
end
