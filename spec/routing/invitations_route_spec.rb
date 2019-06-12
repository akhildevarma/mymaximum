require 'rails_helper'

describe 'invitation routes' do
  it 'routes GET /invitation/new' do
    expect(get: 'invitation/new').to route_to(
      controller: 'invitations',
      action: 'new'
    )
  end

  it 'routes POST /invitation' do
    expect(post: 'invitation').to route_to(
      controller: 'invitations',
      action: 'create'
    )
  end
end
