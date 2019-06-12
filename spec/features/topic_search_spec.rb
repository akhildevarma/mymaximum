require 'feature_helper'

include SessionHelper

feature 'Topic Search', :allow_net_connections, :js, :ignore do
  before { ApplicationController.any_instance.stub(:feature?) { true } }
  scenario 'Search for Xanex' do
    login_as_provider
    visit '/topic_searches'
    click_on 'Begin a New Search'
    fill_in 'Drug name', with: 'Xanax'
    click_on 'Begin Search'
    topic_tabs.each do |provider|
      check_result_for provider
    end
  end

  scenario 'Search for Enbrel' do
    login_as_provider
    visit '/topic_searches'
    click_on 'Begin a New Search'
    fill_in 'Drug name', with: 'Enbrel'
    click_on 'Begin Search'
    topic_tabs.each do |provider|
      check_result_for provider
    end
  end

  def check_result_for(provider = '')
    expect(page).to have_content(provider)
    click_link provider
    operator = (provider.in? ['National Guidelines Clearinghouse']) ? '=~' : '!~'
    matcher = /No #{provider} (topics|results) found\./
    match = !!page.text.send(operator, matcher)
    expect(match).to be true
  end

  def topic_tabs
    ['MedlinePlus', 'National Guidelines Clearinghouse', 'DailyMed', 'Drugs@FDA']
  end

end
