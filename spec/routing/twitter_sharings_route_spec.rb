require 'rails_helper'

describe 'twitter_sharings routes' do
  it 'routes POST /twitter_sharings' do
    expect(post: 'twitter_sharings').to route_to(
      controller: 'twitter_sharings',
      action: 'create'
    )
  end

  it 'routes GET /tw' do
    expect(get: 'tw').to route_to(
      controller: 'twitter_sharings',
      action: 'create'
    )
  end
end
