require 'rails_helper'

describe 'inquiry_copies routes' do
  it 'routes POST /inquiry_copy' do
    expect(post: 'inquiry_copy').to route_to(
      controller: 'inquiry_copies',
      action: 'create'
    )
  end
end
