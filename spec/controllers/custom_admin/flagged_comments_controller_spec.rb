require 'rails_helper'

describe CustomAdmin::FlaggedCommentsController do
  before { login_as_admin }

  let(:inquiry) { create :inquiry }
  let(:parent_comment) { create :comment, user: User.last, referenceable: inquiry}
  let(:flagged_comment) { create :flagged_comment, user: User.last, comment: parent_comment}

  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe 'PUT #update' do
    let(:params) do
      {
        flagged_comment: {
          user_id: User.last.id,
          comment_id: parent_comment.id
        },
        id: flagged_comment.id
      }
    end

    it 'update a comment' do
      put :update, params
      expect(response).to have_http_status(302)
    end
  end

   describe 'DELETE #destroy a flagged comment' do
    let(:params) do
      {
        id: flagged_comment.id
      }
    end
    it 'destroy a flagged comment' do
      delete :destroy, params
      expect(response).to have_http_status(302)
      expect(FlaggedComment.last).to eq(nil)
    end
  end

end

