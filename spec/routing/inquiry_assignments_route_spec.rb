require 'rails_helper'

describe 'inquiry_assignments routes' do
  it 'routes POST /inquiries/:inquiry_id/assignment' do
    expect(post: 'inquiries/1/assignment').to route_to(
      controller: 'inquiry_assignments',
      action: 'create',
      inquiry_id: '1'
    )
  end

  it 'routes DELETE /inquiries/:inquiry_id/assignment' do
    expect(delete: 'inquiries/1/assignment').to route_to(
      controller: 'inquiry_assignments',
      action: 'destroy',
      inquiry_id: '1'
    )
  end
end
