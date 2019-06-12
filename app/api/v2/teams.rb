module V2
  class Teams < Grape::API
  	use ActionDispatch::Session::CookieStore
  	helpers ApiHelpers::TeamHelper

  	desc 'Search team names'
  	params do
  		optional :search, type: String, desc: 'Partial Team name'
  	end

  	get 'teams' do
  		@teams = ( params[:search].present? ? Team.search( params[:search] ) : Team.with_signup_flow )
  		presenter( @teams, V2::TeamSerializer, {}, adapter: :json_api )
  	end

    desc 'Create user'
    params do
      requires :user, type: Hash do
        requires :email, type: String, desc: "Team user's email"
        requires :password, type: String, desc: "Team user's password"
        requires :password_confirmation, type: String, desc: "Team user's password again"
      end
      requires :signup_url_path, type: String, desc: "Team's signup_url_path"
    end

    post '/:signup_url_path/users' do
      validate_all
      @team_signup = User::TeamSignup.new( declared( params ) )   
      if (@user = User.find_by(email: @team_signup.email)) && @user.requires_account_activation?
        @user = @team_signup.validate_user_params(params[:user], @user)
        if @user.errors.any?
          process_modal_errors(@team_signup.user)
        else
          @team_signup.update_user(@user, params)
          presenter(@user, V2::UserSerializer)
        end
      elsif @team_signup.user.valid? && @team_signup.save
        presenter(@team_signup.user, V2::UserSerializer)
      else
        process_modal_errors(@team_signup.user)
      end
    end

  	desc "Validate team user's email"
  	params do
  		requires :email, type: String, desc: "Team user's email address"
  		requires :signup_url_path, type: String, desc: "Teams signup_url_path"
  	end

  	get '/:signup_url_path/users/validate' do
      team_by_path
  		validate_email
  		validate_domain
  		email_taken
      message(:email_valid, 'Email valid') unless @message
  		present @message, with: Entities::Message
  	end

  end
end
