require 'rails_helper'

describe 'GET /application_settings.json' do
  before do
    get '/application_settings.json'
  end

  it 'returns JSON validated by schema' do
    expect(response.body).to match_response_schema('application_settings', :legacy)
  end
end
