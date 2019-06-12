module Authentication
  extend ActiveSupport::Concern

  included do
    helper_method :authenticated?, :team_admin?, :current_user, :administrator?, :admin?, :provider?, :student?, :patient?

    before_filter :set_referer
  end

  def current_user
    @current_user ||= User.find_by_id(session[:user_id]).try :decorate
    @current_user.try :active!
    @current_user
  end




protected
  def login(user)
    session[:user_id] = user.id
  end

  def logout
    session[:user_id] = nil
  end

  def force_logout
    @current_user = session[:user_id] = nil
  end

  def remove_session_original_url
    session[:original_url] = nil
  end



private

  def authenticate # for API calls
    return unless json_request?
    unless authenticated?
      authenticate_with_http_basic do |email, password|
        @current_user = User.authenticate(email, password)
      end
    end

    request_http_basic_authentication and return unless authenticated?
  end

  def authenticated?
    current_user.present?
  end


  def administrator?
    authenticated? && current_user.administrator?
  end

  def team_admin?
    authenticated? && current_user.team_admin?
  end
  alias_method :admin?, :administrator?

  def provider?
    authenticated? && current_user.provider?
  end

  def student?
    authenticated? && current_user.student?
  end

  def patient?
    authenticated? && current_user.patient?
  end

  def require_user
    respond_unauthorized unless authenticated?
  end

  def require_administrator
    return respond_unauthorized unless authenticated?
    respond_forbidden unless administrator?
  end

  def require_provider
    return respond_unauthorized unless authenticated?
    respond_forbidden unless provider? || administrator?
  end

   def require_student_provider
    return respond_unauthorized unless authenticated?
    respond_forbidden unless provider? || student? || administrator?
  end

  def require_student
    return respond_unauthorized unless authenticated?
    respond_forbidden unless student? || administrator?
  end
  alias_method :require_researcher, :require_student

  def respond_unauthorized
    respond_to do |format|
      format.html { redirect_to login_path, alert: I18n.t('errors.not-logged-in') }
      format.json { render json: {}, status: :unauthorized }
    end
  end

  def respond_forbidden
    respond_to do |format|
      format.html { redirect_to root_path, alert: I18n.t('errors.authorization') }
      format.json { render json: {}, status: :forbidden }
    end
  end

  def set_referer
    session[:referer_url] ||= request.referer
  end

  def redirect_to_referer(message={})
    redirect_url = session.delete(:referer_url) || root_path
    redirect_to redirect_url, message
  end

end
