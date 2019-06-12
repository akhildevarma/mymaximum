require 'rails_helper'

describe 'students routes' do
  it 'routes PUT /students/1' do
    expect(put: 'students/1').to route_to(
      controller: 'students',
      action: 'update',
      id: '1'
    )
  end
end
