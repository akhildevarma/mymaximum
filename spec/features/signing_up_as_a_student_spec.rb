require 'feature_helper'

feature 'Signing up as a student' do
  scenario 'Invited student creates an account' do
    student_invitation = FactoryGirl.create(:student_invitation)
    visit new_student_signup_path
    fill_in 'Email',                        with: student_invitation.email
    fill_in 'student_signup_user_password', with: 'kabloomers'
    fill_in 'Confirm Password',             with: 'kabloomers'
    fill_in 'Invitation token',             with: student_invitation.token
    check 'student_signup_accept_terms_of_service'

    click_on 'Create Account'
    expect(page).to have_content('Successfully created student account')
  end

  scenario "A user can't create a student account with a non-student invitation" do
    regular_invitation = FactoryGirl.create(:invitation)
    visit new_student_signup_path
    fill_in 'Email',                        with: regular_invitation.email
    fill_in 'student_signup_user_password', with: 'catface_meowmers'
    fill_in 'Confirm Password',             with: 'catface_meowmers'
    fill_in 'Invitation token',             with: regular_invitation.token
    check 'student_signup_accept_terms_of_service'

    click_on 'Create Account'
    expect(page).to have_content('Oops! There was a problem creating your account.')
  end
end
