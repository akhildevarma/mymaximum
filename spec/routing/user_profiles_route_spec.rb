require 'rails_helper'

describe 'user_profiles routes' do
  it 'routes GET /user_profiles/:id' do
    expect(get: 'user_profiles/1').to route_to(
      controller: 'user_profiles',
      action: 'show',
      id: '1'
    )
  end

  it 'routes GET /user_profiles/:id/edit' do
    expect(get: 'user_profiles/1/edit').to route_to(
      controller: 'user_profiles',
      action: 'edit',
      id: '1'
    )
  end

  it 'routes PUT /user_profiles/:id' do
    expect(put: 'user_profiles/1').to route_to(
      controller: 'user_profiles',
      action: 'update',
      id: '1'
    )
  end
end
