require 'rails_helper'

describe CustomAdmin::CommentsController do
  before { login_as_admin }
  let(:inquiry) { create :inquiry }
  let(:parent_comment) { create :comment, user: User.last, referenceable: inquiry}

  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "get #edit" do
    it "returns http success" do
      get :edit, id: parent_comment.id
      expect(response).to have_http_status(:success)
    end
  end

  describe 'PUT #update' do
    let(:params) do
      {
        comment: {
          title: '',
          body: 'Great comment2!!',
          referenceable_id: inquiry.id,
          referenceable_type: inquiry.class.name
        },
        id: parent_comment.id
      }
    end

    it 'update a comment' do
      put :update, params
      expect(response).to have_http_status(302)
      expect(Comment.last.body).to eq(params[:comment][:body])
    end
  end
end

