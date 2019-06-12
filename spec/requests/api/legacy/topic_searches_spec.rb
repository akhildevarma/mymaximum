require 'rails_helper'

# Feature disabled
describe 'topic_searches', :ignore do
  before(:all) do
    ActionController::Base.allow_forgery_protection = true
  end
  after(:all) do
    ActionController::Base.allow_forgery_protection = false
  end

  before do
    allow(SurveyProcessor).to receive_message_chain(:new, :start_initial_survey) { true }
    allow_any_instance_of(TopicSearch).to receive(:start_queries) { true }
  end

  context 'with an authenticated user' do
    let!(:me) { login_as_provider }

    describe 'POST /topic_searches.json' do
      context 'with valid input' do
        let(:topic_search) { { drug_name: 'lexapro', search_terms: 'depression' } }

        it 'creates a new topic search for the authenticated user' do
          expect do
            post '/topic_searches.json', { topic_search: topic_search }, @env
          end.to change { me.topic_searches.count }.by(1)
        end
      end

      context 'with invalid input' do
        let(:topic_search) { { drug_name: '', search_terms: '' } }
        it 'responds with 422 UNPROCESSABLE ENTITY' do
          post '/topic_searches.json', { topic_search: topic_search }, @env
          expect(response.code).to eq('422')
        end

        it 'contains a hash of errors' do
          post '/topic_searches.json', { topic_search: topic_search }, @env
          parsed_body = JSON.parse(response.body)
          expect(parsed_body).to have_key('errors')
          expect(parsed_body['errors']).to have_key('search_terms')
        end
      end
    end

    describe 'GET /topic_searches/:id/medline_plus_result.json' do
      context "when the query isn't finished" do
        let!(:topic_search) { FactoryGirl.create(:topic_search_skipping_jobs, submitter_id: me.id, medline_plus_query_complete: false) }
        it 'responds with 503 SERVICE UNAVAILABLE' do
          get topic_search_medline_plus_result_path(topic_search, format: :json), {}, @env
          expect(response.code).to eq('503')
        end
      end

      context 'when the result is ready' do
        let!(:topic_search) { FactoryGirl.create(:topic_search_skipping_jobs, submitter: me, medline_plus_query_complete: true, medline_plus_result: nil) }
        it 'responds 200' do
          get topic_search_medline_plus_result_path(topic_search, format: :json), {}, @env
          expect(response.code).to eq('200')
        end
        it 'returns the result as HTML' do
          get topic_search_medline_plus_result_path(topic_search, format: :json), {}, @env
          expect(JSON.parse(response.body)).to have_key('html')
          expect(response.body).to include('No MedlinePlus topics found.')
        end
      end
    end

    describe 'GET /topic_searches/:id/guideline_gov_result.json' do
      context "when the query isn't finished" do
        let!(:topic_search) { FactoryGirl.create(:topic_search_skipping_jobs, submitter_id: me.id, guideline_gov_query_complete: false) }
        it 'responds with 503 SERVICE UNAVAILABLE' do
          get topic_search_guideline_gov_result_path(topic_search, format: :json), {}, @env
          expect(response.code).to eq('503')
        end
      end

      context 'when the result is ready' do
        let!(:topic_search) { FactoryGirl.create(:topic_search_skipping_jobs, submitter: me, guideline_gov_query_complete: true, guideline_gov_result: nil) }
        it 'responds 200' do
          get topic_search_guideline_gov_result_path(topic_search, format: :json), {}, @env
          expect(response.code).to eq('200')
        end
        it 'returns the result as HTML' do
          get topic_search_guideline_gov_result_path(topic_search, format: :json), {}, @env
          expect(JSON.parse(response.body)).to have_key('html')
          expect(response.body).to include('No National Guidelines Clearinghouse results found.')
        end
      end
    end

    describe 'GET /topic_searches/:id/daily_med_result.json' do
      context "when the query isn't finished" do
        let!(:topic_search) { FactoryGirl.create(:topic_search_skipping_jobs, submitter_id: me.id, daily_med_query_complete: false) }
        it 'responds with 503 SERVICE UNAVAILABLE' do
          get topic_search_daily_med_result_path(topic_search, format: :json), {}, @env
          expect(response.code).to eq('503')
        end
      end

      context 'when the result is ready' do
        let!(:topic_search) { FactoryGirl.create(:topic_search_skipping_jobs, submitter: me, daily_med_query_complete: true, daily_med_result: nil) }
        it 'responds 200' do
          get topic_search_daily_med_result_path(topic_search, format: :json), {}, @env
          expect(response.code).to eq('200')
        end
        it 'returns the result as HTML' do
          get topic_search_daily_med_result_path(topic_search, format: :json), {}, @env
          expect(JSON.parse(response.body)).to have_key('html')
          expect(response.body).to include('No DailyMed results found.')
        end
      end
    end

    describe 'GET /topic_searches/:id/fda_result.json' do
      context "when the query isn't finished" do
        let!(:topic_search) { FactoryGirl.create(:topic_search_skipping_jobs, submitter_id: me.id, fda_query_complete: false) }
        it 'responds with 503 SERVICE UNAVAILABLE' do
          get topic_search_fda_result_path(topic_search, format: :json), {}, @env
          expect(response.code).to eq('503')
        end
      end

      context 'when the result is ready' do
        let!(:topic_search) { FactoryGirl.create(:topic_search_skipping_jobs, submitter: me, fda_query_complete: true, fda_result: nil) }
        it 'responds 200' do
          get topic_search_fda_result_path(topic_search, format: :json), {}, @env
          expect(response.code).to eq('200')
        end
        it 'returns the result as HTML' do
          get topic_search_fda_result_path(topic_search, format: :json), {}, @env
          expect(JSON.parse(response.body)).to have_key('html')
          expect(response.body).to include('No Drugs@FDA results found.')
        end
      end
    end
  end

  context 'without an authenticated user' do
    it 'responds with 401 UNAUTHORIZED' do
      post '/topic_searches.json'
      expect(response.code).to eq('401')
    end
  end
end
