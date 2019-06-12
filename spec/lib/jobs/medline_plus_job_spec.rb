require 'rails_helper'

describe MedlinePlusJob, :vcr do
  let(:fake_topic_search) { double(search_terms_with_drug_name: 'asthma and aspirin') }
  let(:fake_topic) { { title: 'Phony Baloney', full_summary: 'A very fake topic' } }
  let(:medline_plus_job) { MedlinePlusJob.new(1) }
  let(:fake_search_results) do
    @results ||= 10.times do |i|
      (results ||= []) << { title: "test#{i}", url: 'test.url', why_prescribed: 'why' }
    end
  end
  let(:fake_search_query) { double(result: fake_search_results, more_results_url: 'www.website.com/more') }

  before do
    allow(fake_topic_search).to receive(:medline_plus_result=)
    allow(fake_topic_search).to receive(:medline_plus_query_complete=)
    allow(fake_topic_search).to receive(:save!)
    allow(fake_search_query).to receive(:results) { fake_search_results }
    allow(fake_search_query).to receive(:more_results_url)
    allow(TopicSearch).to receive(:find) { fake_topic_search }
    allow(MedlinePlus::Search).to receive(:new) { fake_search_query }
  end

  describe '#perform' do
    it "runs a query based on the topic search's search terms" do
      expect(MedlinePlus::Search).to receive(:new).with('asthma and aspirin')
      medline_plus_job.perform
    end

    it "sets the topic search's MedlinePlus topic and a url to more results (as json)" do
      expect(fake_topic_search).to receive(:medline_plus_result=).with({
         data: fake_search_query.results , more_results_url: fake_search_query.more_results_url
       }.to_json)
      medline_plus_job.perform
    end

    it "marks the topic search's MedlinePlus query as completed" do
      expect(fake_topic_search).to receive(:medline_plus_query_complete=).with(true)
      medline_plus_job.perform
    end

    it 'saves the topic search' do
      expect(fake_topic_search).to receive(:save!)
      medline_plus_job.perform
    end
  end
end
