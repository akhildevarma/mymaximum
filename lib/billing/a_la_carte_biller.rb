module Billing
  class ALaCarteBiller < SubscriptionBiller
    include ActionView::Helpers::TextHelper

    def process_inquiry_charge(inquiry)
      charge_accepted(Product.inquiry, I18n.t('billing.inquiry_invoice_item', snippet: truncate(inquiry.question, length: 20))) 
    end

    def process_topic_search_charge(topic_search)
      charge_accepted(Product.topic_search, I18n.t('billing.topic_search_invoice_item', snippet: truncate(topic_search.search_terms_with_drug_name, length: 20)))
    end

    private

    def charge_accepted(product, description)
      begin
        Stripe::InvoiceItem.create(customer: @payment_account.stripe_customer_token, 
                                   amount: price(product),
                                   currency: 'usd',
                                   description: description)
      rescue Stripe::StripeError => e
        @errors << e.message
        NewRelicRemote.report(e)
        false
      end
    end

    def price(product)
      return 0 if @payment_account.trialing?
      product.a_la_carte_price_in_cents
    end
  end
end
