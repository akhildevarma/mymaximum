require 'rails_helper'

describe 'admin/users routes' do
  it 'routes GET /admin/users' do
    expect(get: 'admin/users').to route_to(
      controller: 'admin/users',
      action: 'index'
    )
  end

  it 'routes GET /admin/users/:id' do
    expect(get: 'admin/users/1').to route_to(
      controller: 'admin/users',
      action: 'show',
      id: '1'
    )
  end

  it 'routes DELETE /admin/users/:id' do
    expect(delete: 'admin/users/1').to route_to(
      controller: 'admin/users',
      action: 'destroy',
      id: '1'
    )
  end
end
