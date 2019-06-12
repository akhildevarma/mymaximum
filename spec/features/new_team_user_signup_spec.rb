require 'feature_helper'

feature 'select team and signup as team user' do
 let!(:teams) { create_list :team, 2, :with_5_members }
 let(:team) { teams.last }
 let(:team_id) { team.id }

  before do
    visit signup_path
    teams.each { |team| team.save }
  end
  scenario 'list of teams with logo' do
    expect(page.find("#in-filter-list-input")['placeholder']).to have_content('Select your hospital or group')
    can_have_logo_and_signup_url
    can_signup_without_team

  end

  scenario 'navigates to selected team page' do
    select_team
    can_have_selected_team_page
  end

  def can_have_logo_and_signup_url
    within("#team_#{team_id}") {
      expect(page.find("#team_#{team_id}_signup_url_path")['href']).to have_content(teams.last.signup_url_path)
      # expect(page.find("#team_#{team_id}_logo")['src']).to have_content 'logo.png'
    }
  end

  def can_signup_without_team
    expect(page).to have_link('Continue to Signup',href: new_provider_signup_path)
  end

  def select_team
    within("#team_#{team_id}") {
      page.find("#team_#{team_id}_signup_url_path").click
    }
  end

  def can_have_selected_team_page
    expect(page).to have_content("#{teams.last.name}")
    expect(page).to have_content("@#{teams.last.email_domain}")
  end

end
