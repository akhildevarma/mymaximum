GrapeSwaggerRails.options.before_filter do |request|
  logged_in?
end

def logged_in?# for API calls   
  unless authenticated?
    authenticate_with_http_basic do |email, password|
      @current_user = User.authenticate(email, password)
      session[:user_id] = current_user.id
    end
  end

  request_http_basic_authentication and return unless authenticated?
end

def authenticated?
  current_user.present?
end

def current_user
  if @current_user ||= User.find_by_id(session[:user_id])
    @current_user.try :active!
    @current_user
  end
end

