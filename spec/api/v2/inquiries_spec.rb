require 'rails_helper'

describe 'GET /api/v2/inquiries/' do

  let(:endpoint) { "/api/v2/inquiries" }
  let(:make_request) { get endpoint, {}, @env }
  let(:json) { JSON.parse response.body }
  let!(:me) { login_as_provider_with_token }

  let!(:inquiries) { create_list :completed_inquiry, 10, submitter: me }
  let(:inquiry) { inquiries.first }

  let!(:status) { make_request }
  subject { response }

  it_should_behave_like 'json_api'
  it { is_expected.to have_http_status 200 }

  it 'should be marked as received' do
    new_inquiry = create :completed_inquiry, submitter: me
    persisted_inquiry = Proc.new { Inquiry.find(new_inquiry.id) }.call
    expect( Inquiry.find(new_inquiry.id).received_at ).to eq nil
    get endpoint, {}, @env
    expect( Inquiry.find(new_inquiry.id).received_at ).to_not eq nil
  end

  describe 'unread' do
    it { expect(inquiry.is_unread).to be true }
    subject { json['data'].last }
    it { expect(subject['id']).to eq "#{inquiry.id}" }
    it { expect(subject['attributes']['is-unread']).to be true }
  end

end

describe 'GET /api/v2/inquiries/:id' do
  let(:inquiry) { create :completed_inquiry, submitter: me, read_at: nil }
  let(:endpoint) { "/api/v2/inquiries/#{inquiry.id}" }
  let(:make_request) { get endpoint, {}, @env }
  let(:json) { JSON.parse response.body }

  let!(:me) { login_as_provider_with_token }
  before { make_request }
  subject { response }

  it { is_expected.to have_http_status 200 }
  it_should_behave_like 'json_api'

  context 'user not submitter of inquiry' do
    let(:inquiry) { create :inquiry, read_at: nil }

    it { is_expected.to have_http_status 403 }
    it_should_behave_like 'json_api'
  end

  context 'inquiry does not exist' do
    let(:endpoint) { "/api/v2/inquiries/404" }

    it { is_expected.to have_http_status 404 }
    it_should_behave_like 'json_api'
  end

  context 'unread' do
    context 'should now be marked as read' do
      it { expect(Inquiry.find(inquiry.id).is_unread).to be false }
      subject { json['data'] }
      it { expect(subject['id']).to eq "#{inquiry.id}" }
      it { expect(subject['attributes']['is-unread']).to be false }
    end
  end
end

describe 'GET /api/v2/inquiries/public' do
  let!(:inquiry) { create :completed_inquiry, submitter: me, published_at: Time.now, view_everyone: true }
  let(:endpoint) { '/api/v2/inquiries/public' }
  let(:make_request) { get endpoint, {}, @env }
  let(:json) { JSON.parse response.body }
  let(:data) { json['data'].last }

  let!(:me) { login_as_provider_with_token }
  before { make_request }
  subject { response }
  
  it_should_behave_like 'json_api'
  it { is_expected.to have_http_status 200 }
  it { expect(data['attributes']['view-everyone']).to be true }
  it { expect(data['attributes']['researchable-question']).to be inquiry.researchable_question }
end

describe 'GET /api/v2/inquiries/reopen/:id' do
  context 'when valid ASAP completed inquiry trying reopened' do
    let!(:inquiry) { create :completed_inquiry, turnaround_time: :asap, submitter: me }
    let(:endpoint) { "/api/v2/inquiries/reopen/#{inquiry.id}" }
    let(:make_request) { get endpoint, {}, @env }
    let(:json) { JSON.parse response.body }
    let(:data) { json['data'] }

    let!(:me) { login_as_provider_with_token }
    before { make_request }
    subject { response }
    
    it_should_behave_like 'json_api'
    it { is_expected.to have_http_status 200 }
    it { expect(data['attributes']['hidden-sections']['summary-tables']).to be false }
  end

  context 'when invalid inquiry trying to reopened - non ASAP' do
    let!(:inquiry) { create :completed_inquiry, turnaround_time: :not_urgent, submitter: me }
    let(:endpoint) { "/api/v2/inquiries/reopen/#{inquiry.id}" }
    let(:make_request) { get endpoint, {}, @env }
    let(:json) { JSON.parse response.body }
    let(:data) { json['errors'].last }

    let!(:me) { login_as_provider_with_token }
    before { make_request }
    subject { response }
    
    it_should_behave_like 'json_api'
    it { is_expected.to have_http_status 403 }
    it { expect(data['code']).to eq 'inquiry_does_not_qualify' }
  end

  context 'when invalid inquiry trying to reopened - incomplete inquiry' do
    let!(:inquiry) { create :inquiry, turnaround_time: :asap, submitter: me }
    let(:endpoint) { "/api/v2/inquiries/reopen/#{inquiry.id}" }
    let(:make_request) { get endpoint, {}, @env }
    let(:json) { JSON.parse response.body }
    let(:data) { json['errors'].last }

    let!(:me) { login_as_provider_with_token }
    before { make_request }
    subject { response }
    
    it_should_behave_like 'json_api'
    it { is_expected.to have_http_status 403 }
    it { expect(data['code']).to eq 'inquiry_does_not_qualify' }
  end
end

describe 'GET /api/v2/inquiries/team' do
  let!(:inquiry) { create :completed_inquiry, submitter: me, published_at: Time.now, view_everyone: false }
  let(:endpoint) { '/api/v2/inquiries/team' }
  let(:make_request) { get endpoint, {}, @env }
  let(:json) { JSON.parse response.body }
  let(:data) { json['data'].last }

  let!(:me) { login_as_provider_with_token }
  before { make_request }
  subject { response }
  
  it_should_behave_like 'json_api'
  it { is_expected.to have_http_status 200 }
  it { expect(data['attributes']['view-everyone']).to be false }
end
