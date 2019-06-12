require 'rails_helper'

describe MedlinePlus::HealthTopic, :allow_net_connections do
  describe 'search for aspirin' do
    let(:data) { HTTParty.get('https://wsearch.nlm.nih.gov/ws/query', query: { db: 'healthTopics', rettype: 'topic', term: 'aspirin' }) }

    it 'creates a list of topics from the given hash' do
      expect(MedlinePlus::HealthTopic.list_from_query_result(data)).to have_at_least(1).item
    end

    describe 'attributes' do
      subject { MedlinePlus::HealthTopic.new(data['nlmSearchResult']['list']['document'][0]['content']['health_topic']) }

      its(:title) { should eq('Blood Thinners') }
      its(:url) { should eq('https://medlineplus.gov/bloodthinners.html') }
      its(:full_summary) { should include('probably need regular blood tests') }
      its(:groups) { should include(OpenStruct.new(url: 'https://medlineplus.gov/drugtherapy.html', title: 'Drug Therapy')) }
      its(:mesh_headings) { should include(OpenStruct.new(title: 'Anticoagulants', id: 'D000925')) }
      its(:sites) { should include(OpenStruct.new(information_category: 'Start Here', organization: ['American Heart Association'], title: 'Anti-Clotting Agents Explained', url: 'http://www.strokeassociation.org/STROKEORG/LifeAfterStroke/HealthyLivingAfterStroke/ManagingMedicines/Anti-Clotting-Agents-Explained_UCM_310452_Article.jsp')) }
      its(:related_topics) { should include(OpenStruct.new(title: 'Blood Clots', url: 'https://medlineplus.gov/bloodclots.html')) }
    end
  end
end
