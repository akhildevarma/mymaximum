require 'rails_helper'

describe 'custom_admin/students routes' do
  it 'routes GET /custom_admin/students' do
    expect(get: 'custom_admin/students').to route_to(
      controller: 'custom_admin/students',
      action: 'index'
    )
  end

  it 'routes GET /custom_admin/students/:id' do
    expect(get: 'custom_admin/students/1').to route_to(
      controller: 'custom_admin/students',
      action: 'show',
      id: '1'
    )
  end

  it 'routes PUT /custom_admin/students/:id' do
    expect(put: 'custom_admin/students/1').to route_to(
      controller: 'custom_admin/students',
      action: 'update',
      id: '1'
    )
  end
end
