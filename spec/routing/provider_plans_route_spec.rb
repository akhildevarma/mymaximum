require 'rails_helper'

describe 'provider_plans routes' do
  it 'routes GET /provider_plans' do
    expect(get: 'provider_plans').to route_to(
      controller: 'provider_plans',
      action: 'index'
    )
  end
end
