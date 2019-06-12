class API::Legacy::MyProfilesController < UserProfilesController
  respond_to :json

  before_filter :require_user
  skip_filter :require_can_edit_user
  skip_filter :require_can_view_user
  skip_filter :update_profile_info?

  def show
    @user_profile = UserProfile.for(current_user.decorate)
    respond_with @user_profile, serializer: UserProfileSerializer
  end

  def update
    @user_profile = UserProfile.for(current_user.decorate)
    if @user_profile.update(user_profile_params)
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

  def respond_after_error
    respond_to do |format|
      format.json { render json: errors_for(@user_profile), status: :unprocessable_entity }
    end
  end
end
