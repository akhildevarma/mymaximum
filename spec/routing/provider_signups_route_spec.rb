require 'rails_helper'

describe 'provider_signup routes' do
  it 'routes GET /provider_signup/new' do
    expect(get: 'provider_signup/new').to route_to(
      controller: 'provider_signups',
      action: 'new'
    )
  end

  it 'routes POST /provider_signup' do
    expect(post: 'provider_signup').to route_to(
      controller: 'provider_signups',
      action: 'create'
    )
  end
end
