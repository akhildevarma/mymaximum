require 'rails_helper'

describe 'payment_account' do
  before(:all) do
    ActionController::Base.allow_forgery_protection = true
  end
  after(:all) do
    ActionController::Base.allow_forgery_protection = false
  end

  before do
    allow_any_instance_of(PaymentAccount).to receive(:update_stripe_subscription) { true }
    allow_any_instance_of(PaymentAccount).to receive(:update_card_information) { true }
  end

  context 'with an authenticated provider' do # other users are fine
    let!(:me) { login_as_provider }

    describe 'GET /payment_account.json' do
      before do
        get '/payment_account.json', {}, @env
      end

      it 'returns JSON validated by schema' do
        expect(response.body).to match_response_schema('payment_account', :legacy)
      end
    end

    describe 'PATCH /payment_account.json' do
      context 'with valid input' do
        let(:payment_account) do {
          plan_id: Plan.provider_monthly.id
        }
        end
        it 'responds 204' do
          patch '/payment_account.json', { payment_account: payment_account }, @env
          expect(response.code).to eq('204')
        end
        it "updates the current user's profile" do
          expect do
            patch '/payment_account.json', { payment_account: payment_account }, @env
          end.to change { me.payment_account.reload.plan }.to(Plan.provider_monthly)
        end
      end

      context 'with invalid input' do
        let(:payment_account) do {
          plan_id: 'not_a_plan_id'
        }
        end
        it 'responds 422 UNPROCESSABLE ENTITY' do
          patch '/payment_account.json', { payment_account: payment_account }, @env
          expect(response.code).to eq('422')
        end
        it ' contains a hash of errors' do
          patch '/payment_account.json', { payment_account: payment_account }, @env
          parsed_body = JSON.parse(response.body)
        end
      end
    end
  end
end
