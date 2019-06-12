require 'rails_helper'

describe 'signups routes' do
  it 'routes GET /signup' do
    expect(get: 'signup').to route_to(
      controller: 'signups',
      action: 'new'
    )
  end
end
