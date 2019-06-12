require 'feature_helper'
feature 'No route error' do
  before do
    Rails.application.config.consider_all_requests_local = false
  end
  around do |example|
    default = Rails.application.config.action_dispatch.show_exceptions
    Rails.application.config.action_dispatch.show_exceptions = true
    example.run
    Rails.application.config.action_dispatch.show_exceptions = default
  end
  let!(:team) { create :team }
  context 'no route exist' do
    scenario 'renders not_found template' do
      begin
        visit_non_existing_team_signup_url
      rescue
        expect(page.html).to be_blank
      else
        expect(page.html).to include "The page you were looking for doesn't exist."
      end
    end
  end
  context 'route exist or team exist' do
    before { visit_team_signup_url }
    scenario 'renders visited route' do
      expect(page).to_not have_content "The page you were looking for doesn't exist."
    end
  end

  def visit_team_signup_url
    visit "/#{team.signup_url_path}"
  end

  def visit_non_existing_team_signup_url
    visit "/non-existing-team-name"
  end

end
