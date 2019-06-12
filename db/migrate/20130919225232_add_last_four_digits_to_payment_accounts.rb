class AddLastFourDigitsToPaymentAccounts < ActiveRecord::Migration
  def change
    add_column :payment_accounts, :last_four_digits, :integer
  end
end
