class StripeCustomerRemover
  def self.run(payment_account)
    new(payment_account).run
  end

  def initialize(payment_account, stripe_customer: Stripe::Customer)
    @payment_account = payment_account
    @stripe_customer = stripe_customer
  end

  def run
    return if payment_account.nil? || payment_account.stripe_customer_token.nil?
    stripe_customer.retrieve(payment_account.stripe_customer_token)
      .delete
  end

  private

  attr_reader :payment_account, :stripe_customer
end
