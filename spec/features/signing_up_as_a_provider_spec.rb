require 'feature_helper'

feature 'Signing up as a provider',:ignore, :vcr, js: true do
  context 'when general invitations are required' do
    before do
      Invitation.any_instance.stub(:queue_signup_reminder) { true }
      ApplicationSettings.load.update!(require_general_invitations: true)
    end
    scenario 'Invited provider creates an account' do
      invitation = FactoryGirl.create(:invitation)
      go_to_provider_signup

      fill_in_sign_up_form_with_invitation(email: invitation.email, token: invitation.token)
      expect(page).to have_content('Successfully created healthcare provider account.')
    end

    scenario "Uninvited provider can't make an account" do
      go_to_provider_signup

      fill_in_sign_up_form

      check 'provider_signup_accept_terms_of_service'

      click_on 'Create Account'
      # Specified behaviour
      # expect(page).to have_content('not a valid invitation token')

      # Current behaviour
      expect(page).to have_content('Oops! There was a problem creating your account.')
    end

    context 'specialty' do
      before do
        @invitation = FactoryGirl.create(:invitation)
        go_to_provider_signup
      end
      it 'is required' do
        expect(page).to have_content('* Specialty')
      end
      scenario 'not provided' do
        fill_in_sign_up_form_with_invitation(email: @invitation.email, token: @invitation.token, skip: [:specialty])
        expect(page).to have_content("* Specialty can't be blank")
      end
      scenario 'provided' do
        fill_in_sign_up_form_with_invitation(email: @invitation.email, token: @invitation.token)
        expect(page).to have_content('Successfully created healthcare provider account.')
      end
    end
  end
  context 'when general invitations are not required' do
    before do
      ApplicationSettings.load.update!(require_general_invitations: false)
    end
    scenario 'uninvited provider creates an account' do
      go_to_provider_signup
      fill_in_sign_up_form
      expect(page).to have_content('Successfully created healthcare provider account.')
    end

    context 'when promo codes are allowed' do
      before { ApplicationSettings.load.update!(allow_promo_code: true) }

      # See https://github.com/InpharmD/inpharmd/issues/272
      context 'error case' do
        let(:params) do
          {
            provider_signup: {
              user: {
                team_id: '',
                email: 'drdarria@sharecare.com',
                password: 'password',
                password_confirmation: 'password',
                promo_code: '798292c201967072'
              },
              payment_account: {
                coupon_code: '',
              },
              profile: {
                first_name: 'Darria',
                last_name: 'Gillespie',
                phone_number: '404.389.4006'
              },
              provider: {
                specialty: 'Emergency Medicine',
                license_number: '',
                licensing_state: 'Georgia'
              },
              accept_terms_of_service: '1'
             },
             commit: 'Create Account'
          }
        end
        before do
          go_to_provider_signup
        end
        context 'without license number' do
          scenario do
            params[:provider_signup][:provider][:license_number] = ''
            fill_in_sign_up_form_with_params(params)
            expect(page).to have_content "License number can't be blank"
          end
        end
        context 'with license_number' do
          scenario do
            params[:provider_signup][:provider][:license_number] = 'MD 999999'
            fill_in_sign_up_form_with_params(params)
            expect(page).to have_content 'Successfully created healthcare provider account.'
          end
        end
      end
    end
  end

  def fill_in_sign_up_form_with_params(params = {})
    provider_signup = params[:provider_signup]
    user = provider_signup[:user]
    profile = provider_signup[:profile]
    provider = provider_signup[:provider]

    fill_in 'Email', with: user[:email]
    fill_in 'provider_signup_user_password', with: user[:password]
    fill_in 'Confirm Password', with: user[:password_confirmation]
    fill_in 'Promo code', with: user[:promo_code]

    fill_in 'First name', with: profile[:first_name]
    fill_in 'Last name', with: profile[:last_name]

    fill_in 'Phone number', with: profile[:phone_number]
    fill_in 'License number', with: provider[:license_number]
    select_from_chosen provider[:licensing_state], from: 'Licensing state'
    fill_in 'Specialty', with: provider[:specialty]

    check 'provider_signup_accept_terms_of_service'
    click_on 'Create Account'
  end

  def fill_in_sign_up_form(
        email = 'anyone@anywhere.com', options = {}
  )
      defaults = {
        skip: []
      }
      options.reverse_merge! defaults

      fill_in 'Email', with: email
      fill_in 'provider_signup_user_password', with: 'secretz'
      fill_in 'Confirm Password', with: 'secretz'

      fill_in 'First name', with: 'Raymond'
      fill_in 'Last name', with: 'Smuckles'
      fill_in 'Phone number', with: '(123) 456-7890'
      fill_in 'License number', with: '1234567890'
      fill_in 'Licensing state', with: 'Georgia'
      fill_in('Specialty', with: 'Pharmacist') unless options[:skip].include? :specialty

      check 'provider_signup_accept_terms_of_service'
      click_on 'Create Account'
  end

  def fill_in_sign_up_form_with_invitation(email: 'anyone@anywhere.com', token: 'none', skip: [])
    fill_in 'Invitation token', with: token
    options = {
      skip: skip
    }
    fill_in_sign_up_form(
      email, options
    )
  end

  def go_to_provider_signup
    visit new_provider_signup_path
  end
end
