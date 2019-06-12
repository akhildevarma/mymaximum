require 'feature_helper'

include SessionHelper

feature 'Viewing and editing user profiles' do
  let!(:someone_else) { FactoryGirl.create(:provider_user) }
  def view_someone_elses_profile
    visit "/user_profiles/#{someone_else.id}"
  end

  context 'As a provider' do
    let!(:me) { login_as_provider }

    scenario 'I can edit my own profile' do
      within("#nav-sm") { click_on me.decorate.name }
      within("#nav-sm") { click_on 'My Profile' }
      click_on 'Save Changes'
      expect(page).to have_content('Successfully updated profile')
    end

    scenario "I cannot edit someone else's profile" do
      visit edit_user_profile_path(id: someone_else.id)
      expect(page).to have_content('not authorized')
    end

    scenario "I cannot view someone else's profile" do
      view_someone_elses_profile
      expect(page).to have_content('not authorized')
    end
  end

  context 'As a student' do
    let!(:me) { login_as_student }

    scenario "I can view someone else's profile" do
      view_someone_elses_profile
      expect(page).to have_content(someone_else.email)
    end

    scenario "I cannot edit someone else's profile" do
      visit edit_user_profile_path(id: someone_else.id)
      expect(page).to have_content('not authorized')
    end

    scenario 'I can create a profile if I do not already have one' do
      within("#nav-sm") { click_on 'My Profile' }

      fill_in 'First Name', with: 'Ima'
      fill_in 'Last Name', with: 'Stoodent'
      fill_in 'Phone Number', with: '(770) 123-4567'
      click_on 'Save Changes'

      expect(page).to have_content('Successfully updated profile')
    end
  end

  context 'As an administrator' do
    let!(:me) { login_as_admin }

    scenario "I can view someone else's profile" do
      view_someone_elses_profile
      expect(page).to have_content(someone_else.email)
    end

    scenario "I can edit someone else's profile" do
      view_someone_elses_profile
      click_on 'Edit User Information'
      fill_in 'First Name', with: 'Some other person'
      fill_in 'Last Name', with: 'Some other person'
      fill_in 'Phone Number', with: '(770) 123-4567'
      select 'Dermatology', from: 'Specialty'
      click_on 'Update User Information'

      expect(page).to have_content('Successfully updated profile')
      expect(page).to have_content('Some other person')
    end
  end
end
