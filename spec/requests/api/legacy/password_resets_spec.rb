require 'rails_helper'

describe 'password_reset' do
  describe 'POST /password_reset.json' do
    after { ActionMailer::Base.deliveries = [] }
    context 'with a valid email address' do
      let(:user) { FactoryGirl.create(:user) }

      it 'returns 200' do
        post '/password_reset.json', email: user.email
        expect(response.code).to eq('200')
      end

      it 'creates a new password reset token' do
        post '/password_reset.json', email: user.email
        expect(user.reload.password_reset_token).to_not be_nil
      end

      it 'sends the reset token to the given email' do
        expect do
          post '/password_reset.json', email: user.email
        end.to change { ActionMailer::Base.deliveries.count }.by(1)
      end
    end

    context 'with an invalid email address' do
      let(:email) { 'haxor@leet.net' }

      it "doesn't send an email" do
        expect do
          post '/password_reset.json', email: email
        end.to_not change { ActionMailer::Base.deliveries.count }
      end

      it 'still returns 200' do
        post '/password_reset.json', email: email
        expect(response.code).to eq('200')
      end
    end
  end
end
