require 'rails_helper'

describe 'GET /api/v2/login/' do

  let(:endpoint) { "/api/v2/login" }
  let!(:me) { login_as_provider_with_token }

  subject { response }

  it_should_behave_like 'json_api'
  it { is_expected.to have_http_status 201 }

end
