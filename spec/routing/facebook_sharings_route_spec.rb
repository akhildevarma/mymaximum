require 'rails_helper'

describe 'facebook_sharings routes' do
  it 'routes POST /facebook_sharings' do
    expect(post: 'facebook_sharings').to route_to(
      controller: 'facebook_sharings',
      action: 'create'
    )
  end

  it 'routes GET /fb' do
    expect(get: 'fb').to route_to(
      controller: 'facebook_sharings',
      action: 'create'
    )
  end
end
