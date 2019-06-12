class AddAccountActivationTokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :account_activation_token, :string
  end
end
