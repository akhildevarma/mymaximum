require 'rails_helper'

describe CustomAdmin::TeamsController do
  before { login_as_admin }

  it 'allows expected attributes' do
    attributes = {
      name: 'Team Name',
      signup_url_path: '',
      email_domain: '',
      admin_email: '',
      active: true
    }
    params = ActionController::Parameters.new(team: attributes)
    team_params = CustomAdmin::TeamsController::TeamParams.build(params)
    expect(team_params).to eq(attributes.with_indifferent_access)
  end

end
