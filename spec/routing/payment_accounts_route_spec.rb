require 'rails_helper'

describe 'payment_accounts routes' do
  it 'routes GET /payment_account' do
    expect(get: 'payment_account').to route_to(
      controller: 'payment_accounts',
      action: 'show'
    )
  end

  it 'routes GET /payment_account/edit' do
    expect(get: 'payment_account/edit').to route_to(
      controller: 'payment_accounts',
      action: 'edit'
    )
  end

  it 'routes PUT /payment_account' do
    expect(put: 'payment_account').to route_to(
      controller: 'payment_accounts',
      action: 'update'
    )
  end
end
