class AddPlanIdToPaymentAccount < ActiveRecord::Migration
  def change
    add_reference :payment_accounts, :plan, index: true
  end
end
