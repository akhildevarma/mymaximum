require 'rails_helper'

describe 'application_settings routes' do
  it 'routes GET /application_settings' do
    expect(get: 'application_settings').to route_to(
      controller: 'application_settings',
      action: 'show'
    )
  end

  it 'routes GET /application_settings/edit' do
    expect(get: 'application_settings/edit').to route_to(
      controller: 'application_settings',
      action: 'edit'
    )
  end

  it 'routes PUT /application_settings' do
    expect(put: 'application_settings').to route_to(
      controller: 'application_settings',
      action: 'update'
    )
  end
end
