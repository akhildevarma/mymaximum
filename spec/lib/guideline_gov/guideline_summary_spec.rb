require 'rails_helper'

describe GuidelineGov::GuidelineSummary, :allow_net_connections do
  let(:url_fragment) { '/content.aspx?id=39320' }

  it "partially sanitizes its attributes' html" do
    summary = GuidelineGov::GuidelineSummary.new(url_fragment)
    expect(summary.objectives).to include('<ul>')
    expect(summary.objectives).to_not include('<div>')
  end

  describe 'attributes' do
    subject { GuidelineGov::GuidelineSummary.new(url_fragment) }

    its(:title) { should eq('Diagnosis and treatment of chest pain and acute coronary syndrome (ACS).') }
    its(:url) { should eq('http://www.guideline.gov/content.aspx?id=39320') }
    its(:bibliographic_sources) { should include('Davis T, Bluhm J, Burke R, Iqbal Q') }
    its(:condition) { should include('Chest pain/discomfort') }
    its(:objectives) { should include('To increase the success of emergency intervention for patients with chest pain symptoms suggestive of serious illness') }
    its(:target_population) { should include('Adults presenting with past or present symptoms of chest pain/discomfort and/or indications of acute coronary syndromes') }
    its(:interventions_considered) { should include('Thrombolytics') }
    its(:outcomes_considered) { should include('Diagnostic value of tests') }
  end
end
