require 'rails_helper'

describe 'waitlisted_provider routes' do
  it 'routes GET /waitlisted_provider/new' do
    expect(get: 'waitlisted_provider/new').to route_to(
      controller: 'waitlisted_providers',
      action: 'new'
    )
  end

  it 'routes POST /waitlisted_provider' do
    expect(post: 'waitlisted_provider').to route_to(
      controller: 'waitlisted_providers',
      action: 'create'
    )
  end
end
