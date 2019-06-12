require 'feature_helper'
include SessionHelper

feature 'user signin'  do
  before do
    visit login_path
  end
  scenario 'the login page should not have periods in the links' do
  	
   expect(page).not_to  have_content('Reset your password.')
   expect(page).not_to  have_content('Create an account.')
   expect(page).to  have_content('Forgotten password?')
end
end