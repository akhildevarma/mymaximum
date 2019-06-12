require 'rails_helper'

describe Billing::ALaCarteBiller, :vcr do
  let(:biller) { Billing::ALaCarteBiller.new(payment_account) }
  before do
    allow(Product).to receive(:inquiry) { mock_model(Product, a_la_carte_price_in_cents: 1000) }
    allow(Product).to receive(:topic_search) { mock_model(Product, a_la_carte_price_in_cents: 200) }
    allow(Stripe::Customer).to receive_message_chain(:retrieve, :delinquent).and_return(false)
  end

  context 'with a non-trialing payment account' do
    let(:payment_account) { double(PaymentAccount, stripe_customer_token: '12345', trialing?: false) }
    describe '#process_inquiry_charge' do
      it 'creates a Stripe invoice item for the price of an inquiry' do
        inquiry = double(Inquiry, question: 'foo bar')
        expect(Stripe::InvoiceItem).to receive(:create).with(customer: '12345',
                                                         amount: 1000,
                                                         currency: 'usd',
                                                         description: 'Inquiry: foo bar')
        biller.process_inquiry_charge(inquiry)
      end
    end

    describe '#process_topic_search_charge' do
      it 'creates a Stripe invoice item for the price of a topic search' do
        topic_search = double(TopicSearch, search_terms_with_drug_name: 'baz')
        expect(Stripe::InvoiceItem).to receive(:create).with(customer: '12345',
                                                         amount: 200,
                                                         currency: 'usd',
                                                         description: 'Topic Search: baz')
        biller.process_topic_search_charge(topic_search)
      end
    end
  end

  context 'with a trialing payment account' do
    let(:payment_account) { double(PaymentAccount, stripe_customer_token: '12345', trialing?: true) }
    describe '#process_inquiry_charge' do
      it 'creates a Stripe invoice item for $0' do
        inquiry = double(Inquiry, question: 'foo bar')
        expect(Stripe::InvoiceItem).to receive(:create).with(customer: '12345',
                                                         amount: 0,
                                                         currency: 'usd',
                                                         description: 'Inquiry: foo bar')
        biller.process_inquiry_charge(inquiry)
      end
    end

    describe '#process_topic_search_charge' do
      it 'creates a Stripe invoice item for $0' do
        topic_search = double(TopicSearch, search_terms_with_drug_name: 'baz')
        expect(Stripe::InvoiceItem).to receive(:create).with(customer: '12345',
                                                         amount: 0,
                                                         currency: 'usd',
                                                         description: 'Topic Search: baz')
        biller.process_topic_search_charge(topic_search)
      end
    end
  end

  context 'with a delinquent account' do
    let(:payment_account) { double(PaymentAccount, stripe_customer_token: '12345', trialing?: false) }
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
