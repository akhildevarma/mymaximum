require 'rails_helper'

describe 'POST /api/v2/comments' do
  let(:endpoint) { "/api/v2/comments" }
  let(:inquiry) { create :completed_inquiry, submitter: me, read_at: nil,published_at: Time.now,view_everyone: true }
  let!(:me) { login_as_provider_with_token }
  let(:make_request) { post endpoint, params, @env }
  let(:json) { JSON.parse response.body }

  context 'without parent id' do
    let(:params) do
    {
      comment: {user_id: me.id, body: 'Test comment',referenceable_id:  inquiry.id, referenceable_type: Inquiry}
    }
  end
    before { make_request }
    subject { response }

    it { is_expected.to have_http_status 201 }
    it_should_behave_like 'json_api'
    it { expect(json['data']['attributes']['body']).to eq params[:comment][:body] }
    it { expect(json['data']['attributes']['parent-id']).to be nil }
  end

  context 'with parent id' do
    let(:parent_comment) {
      create :comment
    }
    let(:params) do
      {
        comment: {user_id: me.id,parent_id: parent_comment.id, body: 'Test comment',referenceable_id:  inquiry.id, referenceable_type: Inquiry}
      }
    end
    before { make_request }
    subject { response }

    it { is_expected.to have_http_status 201 }
    it_should_behave_like 'json_api'
    it { expect(json['data']['attributes']['body']).to eq params[:comment][:body] }
    it { expect(json['data']['attributes']['parent-id']).to eq parent_comment.id}
  end

  context 'invalid inquiry' do
    let(:parent_comment) {
      create :comment
    }
    let(:params) do
      {
        comment: {user_id: me.id,parent_id: parent_comment.id, body: 'Test comment',referenceable_id:  123, referenceable_type: Inquiry}
      }
    end
    before { make_request }
    subject { response }

    it { is_expected.to have_http_status 404 }
    it_should_behave_like 'json_api'
   end
  
end

describe 'PUT /api/v2/comments' do
  let(:endpoint) { "/api/v2/comments" }
  let(:comment) { create :comment, body: 'testing' }
  let!(:me) { login_as_provider_with_token }
  let(:make_request) { put endpoint, params, @env }
  let(:json) { JSON.parse response.body }

  context 'editing valid comment' do
    let(:params) do
      {
        comment: { id: comment.id, body: 'editing comment' }
      }
    end
    before { make_request }
    subject { response }

    it { is_expected.to have_http_status 200 }
    it_should_behave_like 'json_api'
    it { expect(json['data']['attributes']['body']).to_not eq comment.body }
  end

   context 'editing invalid comment id' do
    let(:params) do
      {
        comment: { id: 123, body: 'editing comment' }
      }
    end
    before { make_request }
    subject { response }

    it { is_expected.to have_http_status 404 }
    it_should_behave_like 'json_api'
  end  
end

describe 'DELETE /api/v2/comments' do
  let(:endpoint) { "/api/v2/comments" }
  let(:comment) { create :comment, body: 'testing' }
  let!(:me) { login_as_provider_with_token }
  let(:make_request) { delete endpoint, params, @env }
  let(:json) { JSON.parse response.body }

  context 'deleting valid comment' do
    let(:params) do
      {
        comment: { id: comment.id }
      }
    end
    before { make_request }
    subject { response }

    it { is_expected.to have_http_status 200 }
    it_should_behave_like 'json_api'
    it { expect(Comment.last.deleted).to be true }
  end

   context 'deleting invalid comment id' do
    let(:params) do
      {
        comment: { id: 123 }
      }
    end
    before { make_request }
    subject { response }

    it { is_expected.to have_http_status 404 }
    it_should_behave_like 'json_api'
  end  
end

describe 'Flagging /api/v2/comments/flag' do
  let(:endpoint) { "/api/v2/comments/flag" }
  let(:comment) { create :comment, body: 'testing' }
  let!(:me) { login_as_provider_with_token }
  let(:make_request) { put endpoint, params, @env }
  let(:json) { JSON.parse response.body }

  context 'flagging valid comment' do
    let(:params) do
      {
        comment: { id: comment.id, user_id: me.id }
      }
    end
    before { make_request }
    subject { response }

    it { is_expected.to have_http_status 200 }
    it_should_behave_like 'json_api'
    it { expect(FlaggedComment.last).to_not be nil }
  end

   context 'flagging invalid comment id' do
    let(:params) do
      {
        comment: { id: 123, user_id: me.id }
      }
    end
    before { make_request }
    subject { response }

    it { is_expected.to have_http_status 404 }
    it_should_behave_like 'json_api'
  end  
end

describe 'Available /api/v2/comments/list' do
  let(:endpoint) { "/api/v2/comments/list" }
  let(:inquiry) { create :completed_inquiry, submitter: me, read_at: nil,published_at: Time.now,view_everyone: true }
  let(:comments) { create_list :comment, 10, body: 'testing', referenceable_id: inquiry.id, referenceable_type: Inquiry  }
  let!(:me) { login_as_provider_with_token }
  let(:make_request) { get endpoint, params, @env }
  let(:json) { JSON.parse response.body }

  context 'valid inquiry' do
    let(:params) do
      {
        inquiry_id: inquiry.id, user_id: me.id 
      }
    end
    before { make_request }
    subject { response }

    it { is_expected.to have_http_status 200 }
  end

  context 'invalid inquiry' do
    let(:params) do
      {
        inquiry_id: 123, user_id: me.id 
      }
    end
    before { make_request }
    subject { response }

    it { is_expected.to have_http_status 404 }
  end

end
