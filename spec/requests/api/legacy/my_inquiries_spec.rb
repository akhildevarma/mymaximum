require 'rails_helper'

describe 'my_inquiries', :vcr do
  let(:response_json) { JSON.parse(response.body) }
  let(:valid_inquiry_params) do
    { inquiry:
      {
        question: 'how do i do a thing?',
        turnaround_time: 'asap'
      }
    }
  end
  let(:invalid_inquiry_params) do
    { inquiry:
      {
        turnaround_time: 'pretty quick, dude'
      }
    }
  end
  before(:all) do
    ActionController::Base.allow_forgery_protection = true
  end
  after(:all) do
    ActionController::Base.allow_forgery_protection = false
  end
  context 'with an authenticated healthcare provider' do
    let!(:me) { login_as_provider }
    let!(:my_inquiries) { FactoryGirl.create_list(:inquiry_with_table, 3, status: :complete, submitter: me) }

    describe 'GET /my_inquiries.json' do
      before do
        [Date.current, Date.current - 1.day, Date.current - 2.days].each_with_index do |date, index|
          inquiry = my_inquiries[index]
          inquiry.update_attributes(created_at: date)
        end

        get '/my_inquiries.json', {}, @env
      end

      it 'returns JSON validated by schema' do
        expect(response.body).to match_response_schema('my_inquiries', :legacy)
      end

      it "gets the list of the provider's inquiries" do
        expect(response_json).to have(3).items
      end

      it 'returns results in reverse chronological order' do
        dates = response_json.map { |inquiry| Time.at(inquiry['created_at']) }
        expect(dates[0]).to be > dates[1]
        expect(dates[1]).to be > dates[2]
      end

      it 'has the following keys per inquiry: id, created_at, turnaround_time, status, question' do
        inquiry = response_json[0].symbolize_keys
        expect(inquiry).to have_key(:id)
        expect(inquiry).to have_key(:created_at)
        expect(inquiry).to have_key(:turnaround_time)
        expect(inquiry).to have_key(:status)
        expect(inquiry).to have_key(:question)
      end
    end

    describe 'POST /my_inquiries.json' do
      context 'with valid input' do
        it 'creates a new inquiry for the authenticated user' do
          expect do
            post '/my_inquiries.json', valid_inquiry_params, @env
          end.to change { me.submitted_inquiries.count }.by(1)
        end
      end
      context 'with invalid input' do
        before do
          post '/my_inquiries.json', invalid_inquiry_params, @env
        end
        subject { response }
        it { is_expected.to have_http_status 422 }
        it 'contains a hash of errors' do
          expect(response_json).to have_key('errors')
          expect(response_json['errors']).to have_key('question')
          expect(response_json['errors']).to have_key('turnaround_time')
        end
      end
      context 'billing error', :vcr, :ignore_on_codeship do
        let(:provider_with_billing_error) { create :provider_user, :with_billing_error }
        def make_request(env=nil)
          post '/my_inquiries.json', valid_inquiry_params, (env || @env)
        end
        before do
          User.any_instance.stub(:should_be_billed_for_inquiries?) { true }
          login provider_with_billing_error
          make_request(@env)
        end
        subject { response }
        it { is_expected.to have_http_status 422 }
        it 'responds with errors' do
          expect(response_json).to have_key('errors')
          expect(response_json['errors']).to have_key('billing')
        end
        it 'does not create inquiry' do
          expect do
            make_request(@env)
          end.not_to change { Inquiry.count }
        end
      end
    end

    describe 'GET /my_inquiry/:id/summary_tables.json' do
      before do
        # don't bother sending a request to Twilio
        allow_any_instance_of(SurveyProcessor).to receive(:start_initial_survey) {}
        get "/my_inquiries/#{my_inquiries[0].id}/summary_tables.json", {}, @env
      end
      it 'returns JSON validated by schema' do
        expect(response.body).to match_response_schema('inquiry', :legacy)
      end
      it "gets a hash containing a list of the inquiry's summary tables" do
        expect(response_json).to have_key('summary_tables')
        expect(response_json['summary_tables']).to have(1).item
      end

      it 'contains id, body_html, and references per summary table' do
        summary_table = response_json['summary_tables'].first
        expect(summary_table).to have_key('id')
        expect(summary_table).to have_key('body_html')
        expect(summary_table['body_html']).to include('</table>')
        expect(summary_table).to have_key('references')
      end

      it 'also includes information about the inquiry' do
        expect(response_json).to have_key('id')
        expect(response_json).to have_key('created_at')
        expect(response_json).to have_key('question')
      end
    end
  end

  context 'without an authenticated user' do
    it 'responds with 401 UNAUTHORIZED' do
      get '/my_inquiries.json'
      expect(response.code).to eq('401')
    end
  end

  context 'with an authenticated non-provider user' do
    before do
      non_provider = FactoryGirl.create(:user)
      login(non_provider)
    end
    it 'responds with 403 FORBIDDEN' do
      get '/my_inquiries.json', {}, @env
      expect(response.code).to eq('403')
    end
  end
end
