class AddCouponToPaymentAccount < ActiveRecord::Migration
  def change
    add_column :payment_accounts, :coupon_code, :string
  end
end
