require 'feature_helper'

feature 'Team signup' do

  let!(:team) { create :team }
  let!(:user) { build :user }
  let!(:inactive_user) { create :inactive_user, team_id: team.id }
  let!(:email_username) { user.email.split('@').first }
  let!(:provider_user) { create :empty_provider_user, team_id: team.id, account_activated_at: nil }
  let(:email) { Faker::Internet.email }
  scenario 'A person can join a team' do
    visit_team_signup_url
    enter_team_email
    choose_password
    should_be_logged_in_as_new_user
    success?
  end

  context 'activate with same email' do
    before { 
      visit_add_team_signup_url 
    }
    scenario 'invitee can update email and security details' do  
      can_have_email_and_security_details
      choose_password
      success_fully_acctivated?(provider_user.email)
    end
  end

  context 'activate with different email' do
    before { 
      visit_add_team_signup_url 
    }
    scenario 'invitee can update email and security details' do  
      can_have_email_and_security_details
      choose_email
      choose_password
      success_fully_acctivated?(email)
    end
  end

  context 'activate with expired token' do  
    before { 
      provider_user.account_activated_at = Time.now
      provider_user.save(validate: false)
      visit "/#{team.signup_url_path}/#{provider_user.account_activation_token}"
    }
    scenario 'can see already activated message' do  
      expect(page).to have_content("This account is already activated.")
    end
  end

  context 'invalid' do
    before { visit_team_signup_url }

    context 'email username' do
      scenario 'blank' do
        blank_team_email
        expect(page).to have_content("Invalid email")
      end
      scenario 'invalid' do
        invalid_team_email
        expect(page).to have_content("Invalid email")
      end
      scenario 'already used' do
        duplicate_team_email
        expect(page).to have_content("An account with this email already exists. Please login or reset your password.")
      end
    end

  end

  def blank_team_email
    fill_in_email with: ''
    submit
  end

  def invalid_team_email
    fill_in_email with: '!nv@l$d'
    submit
  end

  def duplicate_team_email
    email_domain = team.email_domain
    email_username = build(:user_team_signup).email_username
    email = "#{email_username}@#{email_domain}"
    existing_user = create :user, email: email
    fill_in_email with: email_username
    submit
  end

  def visit_team_signup_url
    visit "/#{team.signup_url_path}"
  end

  def visit_add_team_signup_url
    visit "/#{team.signup_url_path}/#{provider_user.account_activation_token}"
  end

  def can_have_email_and_security_details
    ["Email", 'Password', 'Confirm Password'].each { |label|
      expect(page).to have_content(label)
    }
    expect(page).to have_field('Email', with: provider_user.email)
  end

  def enter_team_email
    fill_in_email with: email_username
    submit
  end

  def choose_email
    fill_in 'user_team_signup_user_email', with: email
  end

  def choose_password
    fill_in 'user_team_signup_user_password', with: 'password'
    fill_in 'user_team_signup_user_password_confirmation', with: 'password'
    check 'user_team_signup_accept_team_of_service_and_privacy_policy'
    click_on "Join #{team.capitalized_name}"
  end

  def submit
    within('#desktop-form') { click_on "Join #{team.capitalized_name}" }
  end

  def success_fully_acctivated?(email)
    expect(User.last.team_id).to eq team.id
    expect(User.last.email).to eq email
    expect(User.last.provider?).to eq true
    should_be_logged_in_as_new_user
  end

  def success?
    expect(User.last.team_id).to eq team.id
    expect(User.last.email.split('@').first).to eq email_username
    expect(User.last.provider?).to eq true
    should_be_logged_in_as_new_user
    receive_an_email(User.last)
  end

  def receive_an_email(user)
    open_email(user.email)
  end

  def should_be_logged_in_as_new_user
    expect(page.get_rack_session_key('user_id')).to eq User.last.id
  end

  def fill_in_email(options)
    within('#desktop-form') { fill_in 'user_team_signup_email_username', options }
  end

end
