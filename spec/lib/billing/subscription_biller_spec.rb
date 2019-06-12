require 'rails_helper'

describe Billing::SubscriptionBiller do
  let(:payment_account) { double(PaymentAccount, stripe_customer_token: '12345') }
  let(:biller) { Billing::SubscriptionBiller.new(payment_account) }
  before do
    allow(Stripe::Customer).to receive_message_chain(:retrieve, :delinquent).and_return(false)
  end
  describe '#process_inquiry_charge' do
    it 'returns true' do
      inquiry = double(Inquiry, question: 'foo bar')
      expect(biller.process_inquiry_charge(inquiry)).to be true
    end
  end

  describe '#process_topic_search_charge' do
    it 'returns true' do
      topic_search = double(TopicSearch, search_terms_with_drug_name: 'baz')
      expect(biller.process_topic_search_charge(topic_search)).to be true
    end
  end

  context 'with a delinquent account' do
    before do
      allow(Stripe::Customer).to receive_message_chain(:retrieve, :delinquent).and_return(true)
    end
    describe '#process_inquiry_charge' do
      it 'returns false' do
        inquiry = double(Inquiry, question: 'foo bar')
        expect(biller.process_inquiry_charge(inquiry)).to be false
      end
    end

    describe '#process_topic_search_charge' do
      it 'returns false' do
        topic_search = double(TopicSearch, search_terms_with_drug_name: 'baz')
        expect(biller.process_topic_search_charge(topic_search)).to be false
      end
    end
  end
end
