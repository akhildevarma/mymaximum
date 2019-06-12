require 'rails_helper'

describe DailyMed::PrescribingInfoHighlights, :allow_net_connections do
  let(:spl) { { setid: 'b49f45d7-432f-4529-b382-3a65f7643e2d', spl_version: '2', published_date: 'August 26, 2013'.to_date, title: 'LEXAPRO (ESCITALOPRAM OXALATE) TABLET [CARDINAL HEALTH]', url: 'http://dailymed.nlm.nih.gov/dailymed/drugInfo.cfm?setid=b49f45d7-432f-4529-b382-3a65f7643e2d' } }

  describe '#initialize' do
    subject { DailyMed::PrescribingInfoHighlights.new(spl) }
    it { is_expected.to_not be_nil }
  end

  context 'when the given SPL has a Prescribing Info Highlights section' do
    let(:spl) { { setid: 'b49f45d7-432f-4529-b382-3a65f7643e2d', spl_version: '2', published_date: 'August 26, 2013'.to_date, title: 'LEXAPRO (ESCITALOPRAM OXALATE) TABLET [CARDINAL HEALTH]', url: 'http://dailymed.nlm.nih.gov/dailymed/drugInfo.cfm?setid=b49f45d7-432f-4529-b382-3a65f7643e2d' } }

    it 'gets the prescribing info highlights for a given SPL hash' do
      html = DailyMed::PrescribingInfoHighlights.new(spl).to_hash[:html]
      expect(html).to include('HIGHLIGHTS OF PRESCRIBING INFO')
    end
  end

  context "when the given SPL doesn't have a Prescribing Info Highlights section" do
    let(:spl) { { setid: 'f414b76d-22e6-4874-b889-bb8ddc76ac7b', spl_version: '4', published_date: 'March 29, 2013'.to_date, title: 'ASPIRIN LOW DOSE SAFETY COATED (ASPIRIN) TABLET, COATED [HEALTHY ACCENTS (DZA BRANDS, LLC)]', url: 'http://dailymed.nlm.nih.gov/dailymed/drugInfo.cfm?setid=f414b76d-22e6-4874-b889-bb8ddc76ac7b' } }

    describe '#to_hash' do
      it 'returns the original SPL hash, but with html == nil' do
        expect(DailyMed::PrescribingInfoHighlights.new(spl).to_hash).to eq(spl.merge(html: nil))
      end
    end
  end
end
