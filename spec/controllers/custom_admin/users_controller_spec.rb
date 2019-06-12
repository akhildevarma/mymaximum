require 'rails_helper'

describe CustomAdmin::UsersController do
  before { login_as_admin }

  describe 'GET #index' do
    let!(:users) { FactoryGirl.create_list :user, 2 }
    before { get :index }

    it 'should return 200' do
      expect(response).to be_success
    end

    it 'should set users and order by created_at' do
      users << Administrator.first.user
      res = UserDecorator.decorate_collection(users)
      expect(assigns(:users)).to match_array(res)
      expect(assigns(:users).map(&:id)).to eq(
        res.sort_by { |u| u.created_at }.reverse.map(&:id)
      )
    end
  end
end
