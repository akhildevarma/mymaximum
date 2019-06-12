module V2
  class UsersDetails < Grape::API
    use ActionDispatch::Session::CookieStore 
    helpers ApiHelpers::TeamHelper
    before do
      error!("Unauthorized", 401) unless authenticated
    end
    helpers do
     def validate_user_details
        validate_email_format
        validate_domain_format
        validate_existing_user
        error!(error_presenter(@errors), 400) if @errors.present?
     end
    end

    desc 'User details'
    namespace :user do
      desc 'Current logged in user details'
      get do
        if current_user.present?
          presenter(current_user, V2::UserSerializer, {}, adapter: :json_api)
        else
          error_msg = 'Unauthorized.'
          error!({ 'error_msg' => error_msg }, 401)
        end
      end

      desc 'Deactivate an user'
      delete do
        if current_user.present?
          current_user.update_attribute(:is_active, false)
          message(:deactivated, 'Deactivated Succesfully')
          present @message, with: Entities::Message
        else
          error_msg = 'Unauthorized.'
          error!({ 'error_msg' => error_msg }, 401)
        end
      end

      desc 'Update user details'
      params do
        requires :email, type: String, desc: 'email'
      end
      put do
        if current_user.present?
          validate_user_details
          current_user.update_attribute(:email, params[:email])
          presenter(current_user, V2::UserSerializer, {}, adapter: :json_api)
        else
          error_msg = 'Unauthorized.'
          error!({ 'error_msg' => error_msg }, 401)
        end
      end

      desc 'Add other email address'
      params do
        requires :email, type: String, desc: 'email'
      end
      put 'add_other_email' do
        if current_user.present?
          validate_user_details
          User::Email.create(email: params[:email], user_id: current_user.id)
          current_user.email = params[:email]
          presenter(current_user, V2::UserSerializer, {}, adapter: :json_api)
        else
          error_msg = 'Unauthorized.'
          error!({ 'error_msg' => error_msg }, 401)
        end
      end

      desc 'Remove other email address'
      params do
        requires :email, type: String, desc: 'email'
      end
      delete 'remove_other_email' do
        if current_user.present?
          validate_user_details
          if other = User::Email.find_by(email: params[:email])
            other.destroy!
            current_user = other.user
            presenter(current_user, V2::UserSerializer, {}, adapter: :json_api)
          else
            error!(error_presenter(JSONAPI::Exceptions::RecordNotFound.new(params[:email]).errors), 404)
          end
        else
          error_msg = 'Unauthorized.'
          error!({ 'error_msg' => error_msg }, 401)
        end
      end

      desc 'set primary email address'
      params do
        requires :email, type: String, desc: 'email'
        requires :is_primary, type: String, desc: 'Is primary email or not'
      end
      put 'set_primary_email' do
        if current_user.present?
          validate_email_format
          validate_domain_format
          error!(error_presenter(@errors), 400) if @errors.present?
          user_email = User::Email.where(email: params[:email]).first
          user_email.update_attribute(:is_primary, (params[:is_primary]=='true')) if user_email.present?
          presenter(current_user, V2::UserSerializer, {}, adapter: :json_api)
        else
          error_msg = 'Unauthorized.'
          error!({ 'error_msg' => error_msg }, 401)
        end
      end
    end
  end
 end
