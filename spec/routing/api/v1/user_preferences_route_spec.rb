require 'rails_helper'

describe do
  it 'routes PUT api/v1/user/preferences' do
    expect(put: 'api/v1/user/preferences').to route_to(
      controller: 'api/v1/user/preferences',
      action: 'update',
      format: 'json'
    )
  end
end
