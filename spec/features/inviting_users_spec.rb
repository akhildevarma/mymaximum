require 'feature_helper'

include SessionHelper

feature 'Inviting users' do
  scenario 'Admin invites user via email' do
    login_as_admin
    visit '/invitation/new'
    fill_in 'Email', with: 'student@mercer.edu'
    select 'Student', from: 'Invitation Type'
    click_on 'Send Invitation'

    expect(page).to have_content('Invitation sent to student@mercer.edu')
  end
end
