module V2
  class ProviderSignups < Grape::API
    helpers ApiHelpers::ProviderHelper

    desc 'Create Provider'
    params do
      requires :accept_terms_of_service, type: String, desc: 'Terms of service'

      requires :user, type: Hash do
        requires :email, type: String, desc: "User's email address"
        requires :password, type: String, desc: "User's password"
        requires :password_confirmation, type: String, desc: "User's password again"
      end

      requires :provider, type: Hash do
        requires :license_number, type: String, desc: "Provider's licence number"
        requires :licensing_state, type: String, desc: "Provider's licence state"
        optional :specialty, type: String, desc: "Provider's specialty"
      end

      requires :profile, type: Hash do
        requires :first_name, type: String, desc: "User's first name"
        requires :last_name, type: String, desc: "User's last name"
        optional :phone_number, type: String, desc: "User's phone number"
      end
    end

    post '/provider_signup' do
      validate_all
      provider_signup = ProviderSignup.new( declared(params) )
      if provider_signup.save
        presenter(provider_signup, V2::ProviderSignupSerializer)
      else
        errors_for(provider_signup)
      end
    end

  end
end
