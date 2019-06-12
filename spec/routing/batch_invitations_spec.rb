require 'rails_helper'

describe 'batch_invitation routes' do
  it 'routes GET /batch_invitation/new' do
    expect(get: 'batch_invitation/new').to route_to(
      controller: 'batch_invitations',
      action: 'new'
    )
  end

  it 'routes POST /batch_invitation' do
    expect(post: 'batch_invitation').to route_to(
      controller: 'batch_invitations',
      action: 'create'
    )
  end
end
