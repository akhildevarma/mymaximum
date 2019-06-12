require 'rails_helper'

describe API::V1::ProviderSignupsController, :vcr, :ignore do
  before do
    ApplicationSettings.load.update!(require_general_invitations: false)
    allow(Stripe::Customer).to receive(:create) { double('Customer', id: '12345') }
  end
  describe 'POST#create' do
    let(:password) { Faker::Internet.password(8) }
    let(:params) do
      {
        format: :json,
        accept_terms_of_service: true,
        provider_signup: {
          user: {
            email: Faker::Internet.email,
            password: password,
            password_confirmation: password
          },
          provider: {
            license_number: Faker::Number.number(10),
            licensing_state: 'GA',
            specialty: 'test specialist'
          },
          profile: {
            first_name: Faker::Name.first_name,
            last_name: Faker::Name.last_name,
            name_title: 'tester',
            city: Faker::Address.city,
            state: 'GA',
            phone_number: Faker::Number.number(10)
          }
        }
      }
    end

    context 'when valid signup' do
      it 'responds :created' do
        allow_any_instance_of(User).to receive(:invitation) { true }
        post :create, params
        expect(response).to be_success
        expect(response).to have_http_status(201)
      end

      it 'creates a new provider' do
        expect do
          post :create, params
        end.to change { Provider.count }.by(1)
      end

      it 'sends a welcome email' do
        expect do
          post :create, params
        end.to change { ActionMailer::Base.deliveries.count }
      end
    end

    context 'when invalid signup' do
      let(:params) do
        {
          format: :json,
          accept_terms_of_service: true,
          provider_signup: {
            user: {
              email: 'not_an_email',
              password: password,
              password_confirmation: 'unmatching_password'
            },
            provider: {
              license_number: Faker::Number.number(10),
              licensing_state: 'GA',
              specialty: 'test specialist'
            },
            profile: {
              first_name: Faker::Name.first_name,
              last_name: Faker::Name.last_name,
              name_title: 'tester',
              city: Faker::Address.city,
              state: 'GA',
              phone_number: Faker::Number.number(10)
            }
          }
        }
      end
      it 'responds 422' do
        post :create, params
        expect(response).not_to be_success
        expect(response).to have_http_status(422)
        expect(response.body).to be_empty
      end
    end
  end
end
