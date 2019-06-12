require 'rails_helper'

describe DailyMedJob do
  let(:fake_topic_search) { double(id: 1, drug_name: 'lexapro') }
  let(:fake_spls) { [{ title: 'LEXAPRO 1' }, { title: 'LEXAPRO 2' }] }
  let(:daily_med_job) { DailyMedJob.new(1) }
  before do
    allow(fake_topic_search).to receive(:daily_med_result=)
    allow(fake_topic_search).to receive(:daily_med_query_complete=)
    allow(fake_topic_search).to receive(:save!)
    allow(TopicSearch).to receive(:find) { fake_topic_search }
    allow(DailyMed::DrugNameSearch).to receive(:new) { double(spls: fake_spls, more_results_url: 'www.website.com/more') }
    allow(DailyMed::PrescribingInfoHighlights).to receive(:new) { |spl| spl.merge(html: 'HIGHLIGHTS OF PRESCRIBING INFO') }
  end

  describe '#perform' do
    it "runs a DailyMed search based on the topic's drug name" do
      expect(DailyMed::DrugNameSearch).to receive(:new).with('lexapro')
      daily_med_job.perform
    end
    
    it 'gets the prescribing info highlights for the first SPL and saves all the SPLs, as well as link to more results' do
      expect(fake_topic_search).to receive(:daily_med_result=).with(
        { data: [{ title: 'LEXAPRO 1', html: 'HIGHLIGHTS OF PRESCRIBING INFO' }, { title: 'LEXAPRO 2' }], more_results_url: 'www.website.com/more' }.to_json
      )
      daily_med_job.perform
    end

    it "marks the topic search's DailyMed query as complete" do
      expect(fake_topic_search).to receive(:daily_med_query_complete=).with(true)
      daily_med_job.perform
    end

    context 'for a topic search with no drug name' do
      let(:fake_topic_search) { double(id: 1, drug_name: nil) }
      it "doesn't run a DailyMed search" do
        expect(DailyMed::DrugNameSearch).not_to receive(:new)
      end

      it "still marks the topic search's DailyMed query as complete" do
        expect(fake_topic_search).to receive(:daily_med_query_complete=).with(true)
        daily_med_job.perform
      end
    end
  end
end
