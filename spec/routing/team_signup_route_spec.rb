require 'rails_helper'

describe 'custom team url path' do
  let(:team_name) { 'Kennestone' }
  let!(:team) { create :team, name: team_name }
  it 'routes GET' do
    expect(get: "/#{team.signup_url_path}").to route_to(
      controller: 'users/team_signups',
      action: 'new',
      signup_url_path: "#{team.signup_url_path}"
    )
  end
  describe TeamSignupMatcher do
    describe '.matches' do
      context 'case insensitive' do
        let(:request) { OpenStruct.new(path: "/#{team.signup_url_path}") }
        subject { TeamSignupMatcher.matches?(request) }
        it { is_expected.to be true }
      end
    end
  end
end
