require 'rails_helper'

describe do
  it 'routes GET api/v1//admin/teams/:team_id/user_upload/processing' do
    expect(get: 'api/v1/admin/teams/:team_id/user_upload/processing').to route_to(
      controller: 'api/v1/admin/teams/user_upload',
      action: 'processing',
      format: 'json',
      team_id: ":team_id"
    )
  end
end
