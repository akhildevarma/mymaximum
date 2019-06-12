require 'rails_helper'

describe 'inquiries routes' do
  it 'routes GET /inquiries' do
    expect(get: 'inquiries').to route_to(
      controller: 'inquiries',
      action: 'index'
    )
  end

  it 'routes GET /inquiries/:id/edit' do
    expect(get: 'inquiries/1/edit').to route_to(
      controller: 'inquiries',
      action: 'edit',
      id: '1'
    )
  end

  it 'routes PUT /inquiries/:id' do
    expect(put: 'inquiries/1').to route_to(
      controller: 'inquiries',
      action: 'update',
      id: '1'
    )
  end

  it 'routes GET /inquiries/closed' do
    expect(get: 'inquiries/closed').to route_to(
      controller: 'inquiries',
      action: 'closed'
    )
  end

  it 'routes GET /inquiries/:id/review' do
    expect(get: 'inquiries/1/review').to route_to(
      controller: 'inquiries',
      action: 'review',
      id: '1'
    )
  end

  it 'routes POST /inquiries/:id/send_response' do
    expect(post: 'inquiries/1/send_response').to route_to(
      controller: 'inquiries',
      action: 'send_response',
      id: '1'
    )
  end
end
