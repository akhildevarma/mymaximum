require 'rails_helper'

describe 'sessions routes' do
  it 'routes GET /session/new' do
    expect(get: 'session/new').to route_to(
      controller: 'sessions',
      action: 'new'
    )
  end

  it 'routes GET /login' do
    expect(get: 'session/new').to route_to(
      controller: 'sessions',
      action: 'new'
    )
  end

  it 'routes POST /session' do
    expect(post: 'session').to route_to(
      controller: 'sessions',
      action: 'create'
    )
  end

  it 'routes DELETE /session' do
    expect(delete: 'session').to route_to(
      controller: 'sessions',
      action: 'destroy'
    )
  end
end
