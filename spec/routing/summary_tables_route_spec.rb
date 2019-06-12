require 'rails_helper'

describe 'summary_tables routes' do
  it 'routes GET /inquiries/:inquiry_id/summary_tables/new' do
    expect(get: 'inquiries/1/summary_tables/new').to route_to(
      controller: 'summary_tables',
      action: 'new',
      inquiry_id: '1'
    )
  end

  it 'routes POST /inquiries/:inquiry_id/summary_tables' do
    expect(post: 'inquiries/1/summary_tables').to route_to(
      controller: 'summary_tables',
      action: 'create',
      inquiry_id: '1'
    )
  end

  it 'routes GET /inquiries/:inquiry_id/summary_tables/:id/edit' do
    expect(get: 'inquiries/1/summary_tables/1/edit').to route_to(
      controller: 'summary_tables',
      action: 'edit',
      inquiry_id: '1',
      id: '1'
    )
  end

  it 'routes PUT /inquiries/:inquiry_id/summary_tables/:id' do
    expect(put: 'inquiries/1/summary_tables/1').to route_to(
      controller: 'summary_tables',
      action: 'update',
      inquiry_id: '1',
      id: '1'
    )
  end

  it 'routes DELETE /inquiries/:inquiry_id/summary_tables/:id' do
    expect(delete: 'inquiries/1/summary_tables/1').to route_to(
      controller: 'summary_tables',
      action: 'destroy',
      inquiry_id: '1',
      id: '1'
    )
  end

  it 'routes GET /summary_table_template' do
    expect(get: 'summary_table_template').to route_to(
      controller: 'summary_tables',
      action: 'template'
    )
  end
end
