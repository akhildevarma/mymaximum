require 'rails_helper'

describe DailyMed::DrugNameSearch, :allow_net_connections do
  let(:search) { DailyMed::DrugNameSearch.new('albuterol') }

  describe '#spls' do

    it 'includes more results url' do
      expect(search.more_results_url).to include("http://dailymed.nlm.nih.gov/dailymed/search.cfm?labeltype=all&query=albuterol")
    end

    it 'gets a list of SPL data for the given drug name' do
      expect(search.spls).to have(7).items
    end

    it 'returns SPLs in hash form' do
      expect(search.spls[0].keys).to match_array([:setid, :spl_version, :published_date, :title, :url])
    end

    it 'sorts the SPL data by date of publication in descending order' do
      expect(search.spls[0][:published_date]).to be > (search.spls[1][:published_date])
    end

    context 'when there are no SPLs for the given drug name', :ignore => true do
      let(:search) { DailyMed::DrugNameSearch.new('not a real drug name') }
      it 'returns an empty list' do
        expect(search.spls).to be_empty
      end
    end
  end

  describe 'caching' do
    before do
      search.spls
      WebMock.stub_request(:any, /dailymed\.nlm\.nih\.gov/).to_raise('made another request')
    end

    it 'caches the SPLs by default' do
      expect(search.spls).to_not be_nil
    end

    it 'reloads when forced' do
      expect { search.spls(force: true) }.to raise_error('made another request')
    end
  end
end
