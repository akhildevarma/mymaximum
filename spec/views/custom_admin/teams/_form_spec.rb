require 'rails_helper'

describe 'custom_admin/teams/_form.html.erb' do
  before do
    @fields = [
      'Name',
      'Admin Email',
      'SignUp URL Path',
      'Email Domain'
    ]
  end

  context 'new' do
    before { @team = Team.new }
    it 'accepts expected fields' do
      render
      for field in @fields
        expect(rendered).to include(field)
      end
    end
  end

  context 'update' do
    before do
      @team = create :team
      @fields << 'Active'
    end
    it 'accepts expected fields' do
      render
      for field in @fields
        expect(rendered).to include(field)
      end
    end
  end
end
