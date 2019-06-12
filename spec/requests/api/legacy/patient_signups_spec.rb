require 'rails_helper'

describe 'provider_signups' do
  before do
    ApplicationSettings.load.update!(require_general_invitations: false)
    allow(Stripe::Customer).to receive(:create) { double('Customer', id: '12345') }
    # FIXME: Problem with ApplicationController line 113 in tests
    stub_const('::PatientSignupErrorSerializer', ::PatientSignupErrorSerializer)
  end

  describe 'POST /patient_signup.json', :vcr do
    context 'with valid input' do
      let(:patient_signup) do {
        user: { email: 'coolguy@patient.biz',
          password: 'foobar',
          password_confirmation: 'foobar'
        },
        profile: {
          first_name: 'Guy',
          last_name: 'Cool',
          name_title: 'Doctorman',
          city: 'Atlanta',
          state: 'GA',
          phone_number: '0009998765' },
        payment_account: {
          plan_id: 2,
          stripe_card_token: 'fakey_1234',
          last_four_digits: '1234'
        },
        accept_terms_of_service: 1
      }
      end

      it 'responds 201' do
        post '/patient_signup.json', patient_signup: patient_signup
        expect(response.code).to eq('201')
      end
      it 'creates a new patient user' do
        expect do
          post '/patient_signup.json', patient_signup: patient_signup
        end.to change { User.count }.by(1)
        expect(User.last).to be_patient
      end
    end

    context 'with invalid input' do
      let(:patient_signup) do  {
        user: { email: 'coolguy@patient.biz',
          password: 'foobar',
          password_confirmation: 'not matching' },
        profile: { first_name: 'Guy' },
        payment_account: { plan: 'a_la_carte',
          last_four_digits: '1234' },
        accept_terms_of_service: 0
      }
      end
      let(:json_error_response) do
        {
          patient_signup: {
            accept_terms_of_service: ['must_be_accepted']
          },
          user: {
            password_confirmation: ['must_match_password']
          },
          patient: {},
          profile: {
             last_name: ['cant_be_blank']
          }
        }.to_json
      end
      it 'responds 422 UNPROCESSABLE ENTITY' do
        post '/patient_signup.json', patient_signup: patient_signup
        expect(response.code).to eq('422')
      end

      it 'contains a hash of errors' do
        post '/patient_signup.json', patient_signup: patient_signup
        expect(response.body).to eq json_error_response
      end
    end
  end
end
