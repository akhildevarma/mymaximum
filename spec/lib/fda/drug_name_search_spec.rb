require 'rails_helper'

describe Fda::DrugNameSearch, :allow_net_connections, :ignore do
  describe '#drug_info' do
    context 'with an ambiguous drug name' do
      let(:drug_name) { 'aspirin' }
      it 'gets a list of links to all matching drug names' do
        search = Fda::DrugNameSearch.new(drug_name)
        expect(search.drug_info).to have_at_least(2).items
        expect(search.drug_info).to satisfy { |info| info.all? { |item| item.key?(:url) && item.key?(:title) } }
      end
    end

    context 'with an unambiguous drug name with multiple FDA applications' do
      let(:drug_name) { 'lexapro' }
      it 'gets a list of links to all matching products' do
        search = Fda::DrugNameSearch.new(drug_name)
        expect(search.drug_info).to have_at_least(2).items
        expect(search.drug_info).to satisfy { |info| info.all? { |item| item.key?(:url) && item.key?(:title) } }
      end

      it 'also gets the basic info for the first matching product' do
        search = Fda::DrugNameSearch.new(drug_name)
        expect(search.drug_info[0]).to have_key(:basic_info)
        expect(search.drug_info[0][:basic_info]).to satisfy { |basic_info| basic_info.all? { |item| item.key?(:label) && item.key?(:value) } }
      end
    end

    context 'with an unambiguous drug name with a single FDA application' do
      let(:drug_name) { 'abraxane' }
      it 'gets the basic info and a link to the product' do
        search = Fda::DrugNameSearch.new(drug_name)
        expect(search.drug_info).to have(1).item
        expect(search.drug_info[0]).to have_key(:basic_info)
        expect(search.drug_info[0]).to have_key(:title)
        expect(search.drug_info[0]).to have_key(:url)
      end
    end

    context 'with a drug name that has no results' do
      let(:drug_name) { 'asfasfasf' }
      it 'returns an empty array' do
        search = Fda::DrugNameSearch.new(drug_name)
        expect(search.drug_info).to eq []
      end
    end
  end
end
