require_relative '../../app/services/user_remover'

describe UserRemover do
  before do
    stub_const('User', Class.new)
  end
  let(:customer_remover) { double('StripeCustomerRemover') }
  let(:payment_account) { double('PaymentAccount') }
  let(:user) do double('User',
                       id: 1,
                       payment_account: payment_account) 
  end
  let(:user_list) { double('User', find: user) }
  let(:user_remover) do UserRemover.new(user.id,
                                        user_list: user_list,
                                        customer_remover: customer_remover) 
  end

  describe '#run' do
    it 'destroys the user and the stripe customer' do
      expect(user).to receive(:destroy)
      expect(customer_remover).to receive(:run)
        .with(payment_account)

      user_remover.run
    end
  end
end
