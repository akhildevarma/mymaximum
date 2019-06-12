require 'rails_helper'

describe API::V1::PasswordResetsController,:ignore do
  describe 'POST#create' do
    context 'with a valid email address' do
      let(:user) { FactoryGirl.build(:user) }
      before do
        allow(User).to receive(:find_by_email).and_return(user)
      end

      it 'calls user#generate_password_reset!' do
        expect(user).to receive(:generate_password_reset!)
        post :create, email: user.email
      end

      it 'sends a password reset email' do
        expect do
          post :create, email: user.email
        end.to change { ActionMailer::Base.deliveries.count }.by(1)
      end

      it 'always responds :ok' do
        post :create, email: user.email
        expect(response).to be_success
        expect(response).to have_http_status(200)
      end
    end

    context 'with a nonexistant email address' do
      before do
        allow(User).to receive(:find_by_email).and_return(nil)
      end

      it 'does not send a password reset email' do
        expect do
          post :create, email: 'something_invalid'
        end.to_not change { ActionMailer::Base.deliveries.count }
      end

      it 'always responds :ok' do
        post :create, email: 'something_invalid'
        expect(response).to be_success
        expect(response).to have_http_status(200)
      end
    end
  end
end
