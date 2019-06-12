require 'feature_helper'

feature 'Signup' do

  before do
    Invitation.any_instance.stub(:queue_signup_reminder) { false }
    ApplicationSettings.load.update!(require_general_invitations: false)
  end

  context 'for user without team. ' do
    let!(:new_user) { build(:provider_user) }
    let(:provider) { new_user.provider }
    let(:profile) { new_user.profile }
    scenario 'They are logged in after completing signup.', :vcr, :js do
      visit_signup_page
      complete_signup_form
      we_should_be_logged_in
    end

  end

  def visit_signup_page
    visit '/provider_signup/new'
    expect(page).to have_content 'Sign Up'
  end

  def complete_signup_form
    fill_in('Email', :with => new_user.email)
    fill_in('provider_signup_user_password', :with => 'test1234')
    fill_in('Confirm Password', :with => 'test1234')

    fill_in('First Name', :with => profile.first_name)
    fill_in('Last Name', :with => profile.last_name)

    fill_in('Phone Number', :with => profile.phone_number)
    fill_in('License Number', :with => provider.license_number)
    select_from_chosen 'California', from: 'Licensing State'

    check 'provider_signup_accept_terms_of_service'
    click_on 'Create Account'

  end

  def we_should_be_logged_in
    expect(page).to_not have_content 'Sign Up'
    expect(page).to_not have_content 'Log In'
    expect(page).to have_content profile.first_name
  end

end
