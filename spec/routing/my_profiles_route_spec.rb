require 'rails_helper'

describe 'my_profiles routes' do
  it 'routes GET /my_profile/edit' do
    expect(get: 'my_profile/edit').to route_to(
      controller: 'my_profiles',
      action: 'edit'
    )
  end

  it 'routes PUT /my_profile' do
    expect(put: 'my_profile').to route_to(
      controller: 'my_profiles',
      action: 'update'
    )
  end
end
