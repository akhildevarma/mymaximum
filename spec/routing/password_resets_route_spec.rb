require 'rails_helper'

describe 'password_reset routes' do
  it 'routes GET /password_reset/new' do
    expect(get: 'password_reset/new').to route_to(
      controller: 'password_resets',
      action: 'new'
    )
  end

  it 'routes POST /password_reset' do
    expect(post: 'password_reset').to route_to(
      controller: 'password_resets',
      action: 'create'
    )
  end

  it 'routes GET /password_reset/edit' do
    expect(get: 'password_reset/edit').to route_to(
      controller: 'password_resets',
      action: 'edit'
    )
  end

  it 'routes PUT /password_reset' do
    expect(put: 'password_reset').to route_to(
      controller: 'password_resets',
      action: 'update'
    )
  end
end
