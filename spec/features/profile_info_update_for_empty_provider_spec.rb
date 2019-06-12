require 'feature_helper'
include SessionHelper

feature 'profile info update for empty provider', :ignore do
  before do
    login_as_empty_provider
  end

  scenario 'Must redirect to edit profile page' do
    redirected_to_edit_profile_page
    visit '/topic_searches'
    update_profile_info
    redirect_to_topic_search_page
  end

  def redirected_to_edit_profile_page
    ["First name can't be blank","Last name can't be blank","Phone number can't be blank"].each {|text|
      expect(page).to have_content text
    }
  end

  def update_profile_info
    fill_in 'First name', with: 'Ima'
    fill_in 'Last name', with: 'Stoodent'
    fill_in 'Title', with: 'Pharmacy Student'
    fill_in 'City', with: 'Macon'
    fill_in 'Specialty', with: 'Hematology'
    fill_in 'License number', with: '12312312'
    select 'Georgia', from: 'State'
    select 'Georgia', from: 'Licensing state'
    fill_in 'Phone number', with: '6759006544'
    click_on 'Update My Profile'
  end

  def redirect_to_topic_search_page
    [
      I18n.t('user_profiles.success'),
      'My Automated Topic Searches'
    ].each { |text| expect(page).to have_content text }
  end

end
