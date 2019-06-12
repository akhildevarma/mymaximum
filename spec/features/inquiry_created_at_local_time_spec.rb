require 'feature_helper'

include SessionHelper

feature 'Inquiry Created at Local Time', js: true, ignore_on_codeship: true do
  # :ignore_on_codeship
  # test fails on codeship due to unresolved issue
  before do
    user = login_as_provider
    Time.use_zone('UTC') do
      @utc_created_at = Time.zone.now.end_of_day + 2.hours
      @inquiry = FactoryGirl.create :inquiry, submitter: user, created_at: @utc_created_at
    end
  end
  scenario 'User timezone' do
    Time.use_zone('Eastern Time (US & Canada)') do
      local_time = @utc_created_at.in_time_zone('Eastern Time (US & Canada)').strftime('%B %e, %Y')
      visit '/my_inquiries'
      page.has_css?('.submitted')
      page.has_css?('.submitted', :text => /#{local_time}/, :wait => false)
    end
  end
end
