require 'feature_helper'

include SessionHelper

feature 'Search Strategy' do

  before do
    login_as_provider
    @inquiry = build :completed_inquiry, submitter: @provider, search_strategy: 'test strategy'
    @inquiry.send_response!
  end

  scenario 'View as part of inquiry response' do
    visit "/my_inquiries/#{@inquiry.id}/summary_tables"
    expect(page).to have_link('Search Strategy', href: '#collapseOne')
    expect(page).to have_content('test strategy')
  end


end
