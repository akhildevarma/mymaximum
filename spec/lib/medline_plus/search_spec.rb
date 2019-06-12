require 'rails_helper'

describe MedlinePlus::Search, :allow_net_connections do
  let(:search) { MedlinePlus::Search.new('xanax') }

  it 'gets the results related to the query' do
    expect(search.results).to have_at_least(10).items
  end

  describe 'caching' do
    before do
      search.results
      WebMock.stub_request(:any, /nlm\.nih\.gov/).to_raise('made another request')
    end

    it 'caches the result by default' do
      expect(search.results).to_not be_nil
    end

    it 'reloads when forced' do
      expect { search.results(force: true) }.to raise_error('made another request')
    end
  end
end
