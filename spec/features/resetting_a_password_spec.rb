require 'feature_helper'
include SessionHelper

feature 'Resetting a password' do
  scenario 'User can reset their password' do
    user = FactoryGirl.create(:user)

    reset_password_for(user: user)

    reset_token = user.reload.password_reset_token

    visit edit_password_reset_path(reset_token: reset_token)
    fill_in 'user_password', with: 'seekrit'
    fill_in 'Confirm Password', with: 'seekrit'
    click_on 'Update Password'

    visit login_path
    fill_login_form_with(email: user.email, password: 'seekrit')

    expect(page).to have_content('Logged in successfully.')
  end

  def reset_password_for(user:)
    visit login_path
    click_on 'Reset your password'
    within('.modal-body') { fill_in 'Email', with: user.email.upcase }
    click_on 'Reset Password'
  end
end
