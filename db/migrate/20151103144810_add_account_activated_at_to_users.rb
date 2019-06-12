class AddAccountActivatedAtToUsers < ActiveRecord::Migration
  def change
    add_column :users, :account_activated_at, :datetime
  end
end
