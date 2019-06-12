module Billing
  class SubscriptionBiller
    attr_reader :errors

    def initialize(payment_account)
      @payment_account = payment_account
      @errors = []
    end

    def process_inquiry_charge(inquiry)
      account_not_delinquent
    end

    def process_topic_search_charge(topic_search)
      account_not_delinquent
    end

    def user_not_delinquent?
      account_not_delinquent
    end

    private

    def account_not_delinquent
      begin
        delinquent = Stripe::Customer.retrieve(@payment_account.stripe_customer_token).delinquent
        @errors << I18n.t('billing.delinquent') if delinquent
        !delinquent
      rescue Stripe::StripeError => e
        @errors << e.message
        NewRelicRemote.report(e)
        false
      end
    end
  end
end
