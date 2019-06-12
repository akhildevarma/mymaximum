class AddActivationTokenToUserEmails < ActiveRecord::Migration
  def change
    add_column :user_emails, :activation_token, :string
    add_column :user_emails, :activated_at, :datetime
  end
end
