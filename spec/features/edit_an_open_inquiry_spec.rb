require 'feature_helper'

include SessionHelper

feature 'Edit an open inquiry' do
  let(:inquiry) { create :inquiry }
  before do
    login_as_student
    visit "/inquiries/#{inquiry.id}/edit"
  end

  scenario 'Valid' do
    fill_in 'Search Strategy', with: 'Ultimate Search'
    click_on 'Save Changes'
    expect(page).to have_content('Inquiry updated successfully')
  end

  scenario 'Not required field' do
    fill_in 'Search Strategy', with: ''
    click_on 'Save Changes'
    expect(page).to have_content('Inquiry updated successfully')
  end

  scenario 'Search strategy placeholder' do
    search_strategy_place_holder = find('#inquiry_search_strategy')['placeholder']
    expect(search_strategy_place_holder).to have_content(
      
      'Include an objective description of your (primary) literature search strategy and how many relevant studies were included for each search (for the Review of Literature section). Example: Pubmed: metformin AND PCOS= [1 included]; PubMed: metformin AND polycystic ovarian syndrome= [3 included]; etc.')
  end

  scenario 'Valid publishable title' do
    fill_in 'Publishable Title', with: 'my inquiry title'
    click_on 'Save Changes'
    expect(Inquiry.first.title).to eq('my inquiry title')
    expect(Inquiry.first.slug).to eq('my-inquiry-title')
    expect(page).to have_content('Inquiry updated successfully')
  end

  scenario 'Invalid publishable title' do
    fill_in 'Publishable Title', with: ''
    click_on 'Save Changes'
    expect(page).to have_content("can't be blank")
  end
end

feature 'email' do
  let!(:profile_user) { create :user_with_profile}
  let!(:profile_inquiry) { create :inquiry, submitter_id: profile_user.id }
  let!(:user) { create :user}
  let!(:inquiry) { create :inquiry, submitter_id: user.id }
  let(:inquiry_id) { profile_inquiry.id }
  
  before do
    login_as_student
  end
scenario 'submitter link can have users name' do
    visit "/inquiries/#{profile_inquiry.id}/edit"
    expect(page).to have_link(profile_user.full_name_or_email,href: user_profile_path(id: profile_inquiry.submitter_id))
  end

  scenario 'submitter link can have users email' do
    visit "/inquiries/#{inquiry.id}/edit"
    expect(page).to have_link(user.email,href: user_profile_path(id: inquiry.submitter_id))
  end
end