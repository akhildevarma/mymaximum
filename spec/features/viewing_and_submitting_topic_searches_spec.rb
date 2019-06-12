require 'feature_helper'

# Feature disabled
feature 'Viewing and submitting topic searches', :vcr, :ignore do
  context 'as a patient' do
    let!(:me) { login_as_patient }

    scenario 'I can submit a new search' do
      visit '/topic_searches'
      click_on 'Begin a New Search'

      fill_in 'Search terms', with: 'can i take aspirin while pregnant?'
      click_on 'Begin Search'

      expect(page).to have_content('Search started successfully')
    end

    context 'with an existing search' do
      let!(:my_search) { TopicSearch.create(search_terms: 'foo bar', submitter: me) }
      let!(:anothers_search) { TopicSearch.create(search_terms: 'baz', submitter: FactoryGirl.create(:user)) }

      scenario 'I can view my previously submitted searches' do
        visit '/topic_searches'
        expect(page).to have_content('foo bar')
      end

      scenario "I cannot view someone else's searches" do
        visit '/topic_searches'
        expect(page).to_not have_content('baz')
      end
    end
  end
end
