require 'feature_helper'

include SessionHelper

feature 'News' do
  let!(:completed) { create_list :completed_inquiry, 5 }
  let!(:published) { create_list :published_inquiry, 5 }
  let!(:guid) { create :guid, referenceable: published.first }

  before do
    login_as_admin
    visit '/'
    within('#nav-sm #admin-nav') { click_on "News" }
  end

  scenario 'admin can remove inquiry' do
    find("#completed_inquiry_#{published.first.id}").click
    expect(page).to have_content("Inquiry was successfully un-published!")
  end
end
