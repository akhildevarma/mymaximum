require 'rails_helper'

describe 'custom_admin/teams/new.html.erb' do
  before do
    @team = Team.new
  end
  it 'renders form' do
    render
    expect(response).to render_template(partial: '_form')
    expect(rendered).to_not include('Active')
    expect(rendered).to include('Create Team')
  end
end
