require 'rails_helper'

describe PasswordResetsController do
  describe 'POST#create' do
    context 'with a valid email address' do
      let(:user) { FactoryGirl.build(:user) }
      before do
        allow(User).to receive(:find_by_email) { user }
      end

      it 'sends a password reset email' do
        expect do
          post :create, email: user.email
        end.to change { ActionMailer::Base.deliveries.count }.by(1)
      end
    end

    context 'with a nonexistant email address' do
      before do
        allow(User).to receive(:find_by_email) { nil }
      end

      it "doesn't send a password reset email" do
        expect do
          post :create, email: 'something_invalid'
        end.to_not change { ActionMailer::Base.deliveries.count }
      end
    end
  end
end
