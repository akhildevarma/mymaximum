require_relative '../../app/services/stripe_customer_remover'

describe StripeCustomerRemover do
  before do
    stub_const('Stripe::Customer', Class.new)
  end
  let(:stripe_customer) { double('Stripe::Customer') }
  let(:payment_account) { double('PaymentAccount', stripe_customer_token: 1) }
  let(:payment_account_without_stripe) { double('PaymentAccount', stripe_customer_token: nil) }

  describe '#run' do
    it 'destroys the stripe customer' do
      customer_remover = StripeCustomerRemover.new(payment_account,
                                                   stripe_customer: stripe_customer)

      expect(stripe_customer).to receive(:retrieve)
        .with(payment_account.stripe_customer_token)
        .and_return(stripe_customer)
      expect(stripe_customer).to receive(:delete)

      customer_remover.run
    end

    it 'does nothing if there is no stripe_customer_token' do
      customer_remover = StripeCustomerRemover.new(payment_account_without_stripe,
                                                   stripe_customer: stripe_customer)

      expect(stripe_customer).not_to receive(:retrieve)
        .with(payment_account.stripe_customer_token)

      customer_remover.run
    end
  end
end
