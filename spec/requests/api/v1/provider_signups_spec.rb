require 'rails_helper'

describe '/api/v1/provider_signups' do
  before do
    ApplicationSettings.load.update!(require_general_invitations: false)
    allow(Stripe::Customer).to receive(:create) { double('Customer', id: '12345') }
    # FIXME: Problem with ApplicationController line 113 in tests
    stub_const('::ProviderSignupErrorSerializer', ::ProviderSignupErrorSerializer)
  end

  let(:endpoint) { '/api/v1/provider_signup' }

  describe 'POST /api/v1/provider_signup', :vcr do
    context 'with valid input' do
      let(:provider_signup) do {
        user: { email: 'coolguy@provider.biz',
          password: 'foobar',
          password_confirmation: 'foobar'
        },
        profile: {
          first_name: 'Guy',
          last_name: 'Cool',
          phone_number: '0009998765'
        },
        provider: {
          license_number: '098382942',
          licensing_state: 'GA',
          specialty: 'Healing'
        },
        payment_account: {},
        accept_terms_of_service: 1
      }
      end

      it 'responds 201' do
        post endpoint, provider_signup: provider_signup
        expect(response.code).to eq('201')
      end
      it 'creates a new provider user' do
        expect do
          post endpoint, provider_signup: provider_signup
        end.to change { User.count }.by(1)
        expect(User.last).to be_provider
      end
      context 'user in team; no license_number', :vcr do
        before do
          allow_any_instance_of(Provider).to receive :queue_payment_reminder
          # user with no license_number and same state already exists
          state = 'GA'
          number = ''
          # ensure database is not enforcing license_number uniqueness
          3.times do
            FactoryGirl.create(:provider_user,
                               provider: Provider.new(
                                 license_number: number,
                                 licensing_state: 'GA'
                               )
                              )
          end
          provider_signup[:user][:team_id] = 1
          provider_signup[:provider][:licensing_state] = state
          provider_signup[:provider][:license_number] = number
          provider_signup[:payment_account][:plan_id] = nil
        end
        it 'responds 201' do
          post endpoint, provider_signup: provider_signup
          expect(response.code).to eq('201')
        end
        it 'creates a new provider user' do
          expect do
            post endpoint, provider_signup: provider_signup
          end.to change { User.count }.by(1)
          expect(User.last).to be_provider
        end
      end
    end

    context 'with invalid input' do
      let(:provider_signup) do
        {
          user: {
            email: 'coolguy@provider.biz',
            password: 'foobar',
            password_confirmation: 'not matching'
          },
          profile: {
            first_name: 'Guy',
            last_name: nil,
            phone_number: nil
          },
          provider: {
              license_number: '098382942',
              licensing_state: nil,
              specialty: nil
          },
          accept_terms_of_service: 0
        }
      end
      let(:json_error_response) do
        {
          provider_signup: {
            accept_terms_of_service: ['must_be_accepted']
          },
          user: {
            password_confirmation: ['must_match_password']
          },
          provider: {
            licensing_state: ['cant_be_blank']
          },
          profile: {
             last_name: ['cant_be_blank']
          },
          payment_account: {}
        }.to_json
      end
      before do
        post endpoint, provider_signup: provider_signup
      end
      it 'responds 422 UNPROCESSABLE ENTITY' do
        expect(response.code).to eq('422')
      end
      it 'contains a hash of errors' do
        expect(response.body).to eq json_error_response
      end
    end
  end
end
