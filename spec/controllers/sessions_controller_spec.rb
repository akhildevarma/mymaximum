require 'rails_helper'

describe SessionsController do
  describe 'POST#create' do
    before do
      request.session[:user_id] = nil
    end

    context 'with a valid email and password' do
      let(:user) { FactoryGirl.create(:user) }

      it 'logs in sucessfully' do
        post :create, email: user.email, password: user.password
        expect(request.session[:user_id]).to be_present
      end

      it 'is case-insensitive on email credentials' do
        post :create, email: user.email.upcase, password: user.password
        expect(request.session[:user_id]).to be_present
      end
    end

    context 'with an invalid email and password' do
      it 'does not log in successfully' do
        post :create, email: 'haxor@evil.biz', password: 'omgwtfbbq'
        expect(request.session[:user_id]).to be_nil
      end
    end
  end

  describe 'DELETE#destroy' do
    before do
      request.session[:user_id] = 1
    end

    it 'logs out successfully' do
      delete :destroy
      expect(request.session[:user_id]).to be_nil
    end
  end
end
