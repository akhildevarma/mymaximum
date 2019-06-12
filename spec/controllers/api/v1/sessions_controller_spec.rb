require 'rails_helper'

describe API::V1::SessionsController,:ignore do
  describe 'POST #create' do
    before do
      request.session[:user_id] = nil
    end

    context 'with a valid email and password' do
      let(:user) { FactoryGirl.create :user }

      it 'logs in successfully' do
        post :create, email: user.email, password: user.password
        expect(request.session[:user_id]).to be_present
        expect(request.session[:user_id]).to eq user.id
        expect(response).to be_success
        expect(response).to have_http_status(200)
      end

      it 'is case-insensitive on email credentials' do
        post :create, email: user.email.upcase, password: user.password
        expect(request.session[:user_id]).to be_present
        expect(request.session[:user_id]).to eq user.id
        expect(response).to be_success
        expect(response).to have_http_status(200)
      end
    end

    context 'with an invalid email or password' do
      it 'does not log in successfully' do
        post :create, email: 'haxor@evil.biz', password: 'omgwtfbbq'
        expect(request.session[:user_id]).to be_nil
        expect(response).not_to be_success
        expect(response).to have_http_status(401)
      end
    end
  end

  describe 'DELETE #destroy' do
    before do
      request.session[:user_id] = 1
      delete :destroy
    end

    it 'always returns :ok status' do
      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it 'sets user_id on session to nil' do
      expect(request.session[:user_id]).to be_nil
    end
  end
end
