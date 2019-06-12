require 'rails_helper'

describe 'survey_responses routes' do
  it 'routes PUT /survey_responses' do
    expect(get: 'survey_responses').to route_to(
      controller: 'survey_responses',
      action: 'index'
    )
  end
end
