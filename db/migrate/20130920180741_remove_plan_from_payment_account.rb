class RemovePlanFromPaymentAccount < ActiveRecord::Migration
  def change
    remove_column :payment_accounts, :plan, :string
  end
end
