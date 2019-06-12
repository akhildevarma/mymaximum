class AddStripeCustomerTokenToPaymentAccounts < ActiveRecord::Migration
  def change
    add_column :payment_accounts, :stripe_customer_token, :string
  end
end
