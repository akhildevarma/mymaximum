require 'rails_helper'

describe GuidelineGovJob do
  let(:fake_topic_search) { double(id: 1, search_terms_with_drug_name: 'diabetes') }
  let(:fake_guideline) { { title: 'Fake diabetes guideline' } }
  let(:guideline_gov_job) { GuidelineGovJob.new(1) }
  before do
    allow(fake_topic_search).to receive(:guideline_gov_result=)
    allow(fake_topic_search).to receive(:guideline_gov_query_complete=)
    allow(fake_topic_search).to receive(:save!)
    allow(TopicSearch).to receive(:find) { fake_topic_search }
    allow(GuidelineGov::Search).to receive(:new) { double(first_result: fake_guideline, more_results_url: 'www.website.com/more') }
  end

  describe '#perform' do
    it "runs a Guideline.gov search based on the topic's search terms" do
      expect(GuidelineGov::Search).to receive(:new).with('diabetes')
      guideline_gov_job.perform
    end
    
    it "sets the topic search's Guideline.gov result and a link to more results (as json)" do
      expect(fake_topic_search).to receive(:guideline_gov_result=).with({ data: fake_guideline, more_results_url: 'www.website.com/more' }.to_json)
      guideline_gov_job.perform
    end

    it "marks the topic search's Guideline.gov query as complete" do
      expect(fake_topic_search).to receive(:guideline_gov_query_complete=).with(true)
      guideline_gov_job.perform
    end

    it 'saves the topic search' do
      expect(fake_topic_search).to receive(:save!)
      guideline_gov_job.perform
    end
  end
end
