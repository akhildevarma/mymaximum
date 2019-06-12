require 'rails_helper'

describe 'custom_admin/teams/show.html.erb' do
  before do
    @team = create :team
  end
  it 'renders form' do
    render
    expect(response).to render_template(partial: '_form')
    expect(rendered).to include('Active')
    expect(rendered).to include('Update Team')
  end
end
