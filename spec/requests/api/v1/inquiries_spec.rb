require 'rails_helper'

def nested_hash_key(obj,key)
  if obj.respond_to?(:key?) && obj.key?(key)
    true
  elsif obj.respond_to?(:each)
    r = nil
    obj.find{ |*a| r=nested_hash_key(a.last,key) }
    r
  end
end

describe '/api/v1/inquiries/:id' do
  let(:endpoint) { "/api/v1/inquiries/#{inquiry.id}" }
  let(:make_request) { get endpoint, {}, @env }
  let(:json) { JSON.parse response.body }

  let!(:me) { login_as_provider }
  let(:inquiries) { FactoryGirl.create_list(:inquiry_with_table, 3, status: :complete, submitter: me) }
  let(:other_inquiries) { FactoryGirl.create_list(:inquiry_with_table, 3, status: :complete) }

  describe 'GET' do
    let(:inquiry) { inquiries.first }
    before do
      # don't bother sending a request to Twilio
      allow_any_instance_of(SurveyProcessor).to receive(:start_initial_survey) {}
      make_request
    end

    it 'returns JSON validated by schema' do
      expect(response.body).to match_response_schema('inquiry', :v1)
    end

    describe 'table_format parameter' do
      let(:table_response) { json["literature_review"]["summary_tables"][0]["table"] }
      context 'formatted' do
        it 'returns only formatted' do
          get endpoint, { table_format: 'formatted' }, @env
          expect(table_response).to have_key "formatted"
          expect(table_response).to_not have_key "unformatted"
        end
      end

      context 'unformatted' do
        it 'returns only formatted' do
          get endpoint, { table_format: 'unformatted' }, @env
          expect(table_response).to have_key "unformatted"
          expect(table_response).to_not have_key "formatted"
        end
      end

      context 'both' do
        it 'returns both formatted and unformatted' do
          get endpoint, { table_format: 'both' }, @env
          expect(table_response).to have_key "formatted"
          expect(table_response).to have_key "unformatted"
        end
      end

      context 'default' do
        it 'returns only formatted' do
          get endpoint, {}, @env
          expect(table_response).to have_key "formatted"
          expect(table_response).to_not have_key "unformatted"
        end
      end

    end

    context 'error' do
      let(:inquiry) { other_inquiries.first }
      before do
        inquiries
        make_request
      end
      subject { response }
      it { is_expected.to have_http_status 404 }
      its(:body) { is_expected.to include('errors') }
    end
  end
end
