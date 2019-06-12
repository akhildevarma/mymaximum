require 'rails_helper'

describe 'interventions routes' do
  it 'routes POST /interventions' do
    expect(post: 'interventions').to route_to(
      controller: 'interventions',
      action: 'create'
    )
  end
end
