class CreatePaymentAccounts < ActiveRecord::Migration
  def change
    create_table :payment_accounts do |t|
      t.belongs_to :user, index: true, unique: true
      t.string :plan, null: false

      t.timestamps
    end
  end
end
