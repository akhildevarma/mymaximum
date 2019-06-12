require 'rails_helper'

describe 'waitlisted_patient routes' do
  it 'routes GET /waitlisted_patient/new' do
    expect(get: 'waitlisted_patient/new').to route_to(
      controller: 'waitlisted_patients',
      action: 'new'
    )
  end

  it 'routes POST /waitlisted_patient' do
    expect(post: 'waitlisted_patient').to route_to(
      controller: 'waitlisted_patients',
      action: 'create'
    )
  end
end
