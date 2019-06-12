require 'rails_helper'

describe PaymentAccount, :vcr do
  context 'with a valid payment account' do
    let(:user) { FactoryGirl.create(:user) }
    let(:plan) { mock_model(Plan, name: 'a_la_carte', id: 1) }
    let(:payment_account) { FactoryGirl.build(:payment_account, user: user, plan: plan, stripe_card_token: '12345', stripe_customer_token: nil) }

    before(:each) do
      allow(Plan).to receive(:plans_for_user_role).and_return([plan])
    end

    describe '#save_with_payment!' do
      before do
        allow(Stripe::Customer).to receive(:create).and_return(double('Customer', id: '67890'))
      end
      it 'creates a Stripe customer' do
        Timecop.freeze(PaymentAccount::PILOT_PROGRAM_END_DATE + 1.day) do
          trial_end = (DateTime.now + 90.days).utc.at_end_of_day.to_i
          expect(Stripe::Customer).to receive(:create) { |hash|
            expect(hash[:description]).to eq(user.email)
            expect(hash[:plan]).to eq('a_la_carte')
            expect(hash[:card]).to eq('12345')
            expect(hash[:trial_end]).to eq(trial_end)
          }.and_return(double('Customer', id: '67890'))
          payment_account.save_with_payment!
        end
      end

      it 'saves the resulting customer token' do
        payment_account.save_with_payment!
        expect(payment_account.reload.stripe_customer_token).to eq('67890')
      end
    end

    describe '#save' do
      let(:payment_account) { FactoryGirl.create(:payment_account, user: user, plan: plan, stripe_customer_token: '12345') }

      context "when the user's plan changes" do
        let(:new_plan) { mock_model(Plan, name: 'provider_yearly', id: 2) }
        before(:each) do
          allow(Plan).to receive(:plans_for_user_role).and_return([plan, new_plan])
          payment_account.plan = new_plan
        end

        it 'saves the new plan to Stripe' do
          customer = double('Customer')
          expect(Stripe::Customer).to receive(:retrieve).with('12345').and_return(customer)
          expect(customer).to receive(:update_subscription) do |hash|
            expect(hash[:plan]).to eq('provider_yearly')
          end
          payment_account.save
        end

        context 'when the user is trialing' do
          before do
            allow(payment_account).to receive(:trialing?) { true }
          end
          it "also passes the user's current trial end date" do
            customer = double('Customer')
            expect(Stripe::Customer).to receive(:retrieve).with('12345').and_return(customer)
            expect(customer).to receive(:update_subscription) do |hash|
              expect(hash[:trial_end]).to eq(payment_account.trial_expires_at.to_i)
            end
            payment_account.save
          end
        end

        context 'when the user is not trialing' do
          before do
            allow(payment_account).to receive(:trialing?) { false }
          end

          it 'does not pass the trial end date' do
            customer = double('Customer')
            expect(Stripe::Customer).to receive(:retrieve).with('12345').and_return(customer)
            expect(customer).to receive(:update_subscription) do |hash|
              expect(hash).to_not have_key(:trial_end)
            end
            payment_account.save
          end
        end
      end

      context "when the user's card changes" do
        let(:new_card_token) { '99999' }
        before(:each) do
          payment_account.stripe_card_token = new_card_token
        end

        it 'saves the new card to stripe' do
          customer = double('Customer')
          allow(customer).to receive_message_chain(:cards, :data, :[], :last4).and_return('1234')
          expect(Stripe::Customer).to receive(:retrieve).with('12345').and_return(customer)
          expect(customer).to receive(:card=).with('99999')
          expect(customer).to receive(:save).and_return(customer)
          payment_account.save
        end
      end
    end
  end
end
