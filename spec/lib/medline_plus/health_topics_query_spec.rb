require 'rails_helper'

describe MedlinePlus::HealthTopicsQuery, :allow_net_connections do
  let(:query) { MedlinePlus::HealthTopicsQuery.new('asthma') }

  it 'gets a list of topics related to the query' do
    expect(query.topics).to have_at_least(1).item
  end

  describe 'caching' do
    before do
      query.topics
      WebMock.stub_request(:any, /wsearch\.nlm\.nih\.gov\/ws/).to_raise('made another request')
    end

    it 'caches the topics by default' do
      expect(query.topics).to have_at_least(1).item
    end

    it 'reloads when forced' do
      expect { query.topics(force: true) }.to raise_error('made another request')
    end
  end
end
