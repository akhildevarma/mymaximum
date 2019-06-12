require 'rails_helper'
describe 'GET /api/v2/docs/team_docs/:id' do
  let!(:user) { create :user }
  let!(:team) { create :team }
  let!(:team_documents) { create_list :document,5, user: user, status: :complete, referenceable: team}
  let(:endpoint) { "/api/v2/docs/team_docs/#{team.id}" }
  let(:make_request) { get endpoint, {}, @env }
  let(:json) { JSON.parse response.body }
  let(:data) { json['data'].last }

  let!(:me) { login_as_provider_with_token }
  before { make_request }
  subject { response }

  it { is_expected.to have_http_status 200 }
  it_should_behave_like 'json_api'
  it { expect(data['attributes']['url']).to_not eq (nil)}
  it { expect(data['attributes']['file-file-name']).to_not eq (nil)}
end
