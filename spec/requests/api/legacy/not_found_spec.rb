require 'rails_helper'

describe 'resources not found' do

  let(:uri) { '/not_existent_resource/1234' }

  it 'raises error' do
    expect { get uri }.to raise_error ActionController::RoutingError
  end

end
