require 'rails_helper'

describe 'twilio_sms_responses routes' do
  it 'routes POST /twilio_sms_responses' do
    expect(post: 'twilio_sms_responses').to route_to(
      controller: 'twilio_sms_responses',
      action: 'create'
    )
  end
end
