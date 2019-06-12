 module V2
  class Login < Grape::API
  	use ActionDispatch::Session::CookieStore

  	helpers do
	   def session
	     env['rack.session']
	   end
  	end

  	desc 'User Authentication'
	  namespace :login do
	    desc 'Login via email and password'
	    params do
	      requires :email, type: String, desc: 'email'
	      requires :password, type: String, desc: 'password'
	    end

	    post do
        email = (params[:email] || '').downcase
	    	user = User.for_authentication(email: email)
	    	if user.present? && user.authenticate(params[:password])
	    		key = user.api_keys.last
	    		key = ((key && !key.expired?) ? key : APIKey.create(user_id: user.id))
	    		session[:user_id] = user.id
          user.update_attribute(:is_active, true)
          user.email = email
      		presenter(key, V2::LoginSerializer, {}, adapter: :json_api)
			  else
			    error_msg = 'Unauthorized.'
			    error!({ 'error_msg' => error_msg }, 401)
			  end
	    end

	  end
  end
 end
