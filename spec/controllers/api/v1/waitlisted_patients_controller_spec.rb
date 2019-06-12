require 'rails_helper'

describe API::V1::WaitlistedPatientsController, :ignore do
  describe 'POST#create' do
    let(:email) { 'new@email.com' }
    let(:params) do
      {
        waitlisted_user: {
          email: email
        }
      }
    end

    context 'when email is valid' do
      it 'responds :ok' do
        post :create, params
        expect(response).to be_success
        expect(response).to have_http_status(200)
      end

      it 'creates a new waitlisted provider' do
        expect do
          post :create, params
        end.to change { WaitlistedUser.count }.by(1)
        expect(WaitlistedUser.last.provider).to be false
      end
    end

    context 'when email is invalid' do
      let(:email) { nil }

      it 'responds with :bad_request' do
        post :create, params
        expect(response).not_to be_success
        expect(response).to have_http_status(400)
      end

      it 'does not create a new waitlisted user' do
        expect do
          post :create, params
        end.not_to change { WaitlistedUser.count }
      end
    end
  end
end
