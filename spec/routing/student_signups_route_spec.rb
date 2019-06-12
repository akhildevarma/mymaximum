require 'rails_helper'

describe 'student_signup routes' do
  it 'routes GET /student_signup/new' do
    expect(get: 'student_signup/new').to route_to(
      controller: 'student_signups',
      action: 'new'
    )
  end

  it 'routes POST /student_signup' do
    expect(post: 'student_signup').to route_to(
      controller: 'student_signups',
      action: 'create'
    )
  end
end
