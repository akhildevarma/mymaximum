class AddIsPrimaryToEmail < ActiveRecord::Migration
  def change
     add_column :user_emails, :is_primary, :boolean
  end
end
