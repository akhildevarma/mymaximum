require 'rails_helper'

describe GuidelineGov::Search, :allow_net_connections do
  let(:search) { GuidelineGov::Search.new('diabetes') }

  it 'gets the first guideline related to the query' do
    expect(search.first_result).to_not be_nil
  end

  describe 'caching' do
    before do
      search.first_result
      WebMock.stub_request(:any, /guideline\.gov/).to_raise('made another request')
    end

    it 'caches the result by default' do
      expect(search.first_result).to_not be_nil
    end

    it 'reloads when forced' do
      expect { search.first_result(force: true) }.to raise_error('made another request')
    end
  end
end
