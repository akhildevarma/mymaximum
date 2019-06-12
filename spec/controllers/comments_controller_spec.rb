require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  before :each do
    login_as_admin
  end

  let(:inquiry) { create :inquiry }
  let(:parent_comment) { create :comment, user: User.last, referenceable: inquiry}

  describe 'POST #create' do
    let(:params) do
      {
        comment: {
          title: '',
          body: 'Great comment!!',
          referenceable_id: inquiry.id,
          referenceable_type: inquiry.class.name
        },
        format: 'js'
      }
    end
    context 'for root/parent of the comment' do
      it 'creates a comment' do
        post :create, params
        expect(response).to have_http_status(200)
        expect(Comment.last.body).to eq(params[:comment][:body])
      end
    end

    context 'for nested comment' do
      it 'creates a child comment' do
        params[:comment][:parent_id] = parent_comment.id
        post :create, params
        expect(response).to have_http_status(200)
        expect(Comment.last.body).to eq(params[:comment][:body])
        expect(Comment.last.parent).to eq(parent_comment)
      end
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
        id: parent_comment.id,
        format: 'json'
      }
    end

    it 'update a comment' do
      put :update, params
      expect(response).to have_http_status(204)
      expect(Comment.last.body).to eq(params[:comment][:body])
    end
  end

  describe 'PUT #flag a comment' do
    let(:params) do
      {
        id: parent_comment.id,
        format: 'js'
      }
    end
    it 'flag a comment' do
      put :flag, params
      expect(response).to have_http_status(200)
      expect(FlaggedComment.last.comment).to eq(parent_comment)
    end
  end

  describe 'DELETE #destroy a comment' do
    let(:params) do
      {
        id: parent_comment.id,
        format: 'js'
      }
    end
    it 'destroy a comment- soft delete only' do
      delete :destroy, params
      expect(response).to have_http_status(200)
      expect(Comment.last.deleted).to eq(true)
    end
  end

end
