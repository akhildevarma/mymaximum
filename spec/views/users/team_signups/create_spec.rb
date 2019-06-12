require 'rails_helper'

describe 'users/team_signups/create.html.erb' do
  let(:team) { create :team }
  let(:page) { Capybara::Node::Simple.new( rendered ) }
  let(:text_elements) {
    [
      team.capitalized_name,
      'Choose a password to create your account.',
      'I have read and agree to the Terms of Use and Privacy Policy'
    ]
  }
  let(:button_elements) {
    ["Join #{team.capitalized_name}"]
  }
  before do
    @team_signup = build :user_team_signup, team: team
    render template: 'users/team_signups/create', layout: 'layouts/main'
  end

  subject { page }
  it_behaves_like 'view_with_known_elements'

end
