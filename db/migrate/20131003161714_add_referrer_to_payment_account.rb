class AddReferrerToPaymentAccount < ActiveRecord::Migration
  def change
    add_reference :payment_accounts, :referrer, index: true
  end
end
