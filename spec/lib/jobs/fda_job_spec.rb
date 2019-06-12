require 'rails_helper'

describe FdaJob do
  let(:fake_topic_search) { double(id: 1, drug_name: 'lexapro') }
  let(:fda_job) { FdaJob.new(1) }
  before do
    allow(fake_topic_search).to receive(:fda_result=)
    allow(fake_topic_search).to receive(:fda_query_complete=)
    allow(fake_topic_search).to receive(:save!)
    allow(TopicSearch).to receive(:find) { fake_topic_search }
    allow(Fda::DrugNameSearch).to receive(:new) { double(drug_info: [{ title: 'LEXAPRO', url: 'www.website.com/lexapro' }], more_results_url: 'www.website.com/more') }
  end

  describe '#perform' do
    it "runs a Drugs@FDA search based on the topic's drug name" do
      expect(Fda::DrugNameSearch).to receive(:new).with('lexapro')
      fda_job.perform
    end
    
    it 'sets the resulting drug info and a link to more results' do
      expect(fake_topic_search).to receive(:fda_result=).with(
        { data: [{ title: 'LEXAPRO', url: 'www.website.com/lexapro' }], more_results_url: 'www.website.com/more' }.to_json
      )
      fda_job.perform
    end

    it "marks the topic search's FDA query as complete" do
      expect(fake_topic_search).to receive(:fda_query_complete=).with(true)
      fda_job.perform
    end

    context 'for a topic search with no drug name' do
      let(:fake_topic_search) { double(id: 1, drug_name: nil) }
      it "doesn't run a Drugs@FDA search" do
        expect(Fda::DrugNameSearch).not_to receive(:new)
      end

      it "still marks the topic search's FDA query as complete" do
        expect(fake_topic_search).to receive(:fda_query_complete=).with(true)
        fda_job.perform
      end
    end
  end
end
