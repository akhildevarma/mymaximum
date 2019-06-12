require 'rails_helper'

describe 'my_inquiries routes' do
  it 'routes GET /my_inquiries' do
    expect(get: 'my_inquiries').to route_to(
      controller: 'my_inquiries',
      action: 'index'
    )
  end

  it 'routes POST /my_inquiries' do
    expect(post: 'my_inquiries').to route_to(
      controller: 'my_inquiries',
      action: 'create'
    )
  end

  it 'routes GET /my_inquiries/:id/summary_tables' do
    expect(get: 'my_inquiries/1/summary_tables').to route_to(
      controller: 'my_inquiries',
      action: 'summary_tables',
      id: '1'
    )
  end
end
