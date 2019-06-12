class AddNotNullConstraintToUserEmails < ActiveRecord::Migration
  def change
    change_column :user_emails, :email, :string, :null => false
  end
end
