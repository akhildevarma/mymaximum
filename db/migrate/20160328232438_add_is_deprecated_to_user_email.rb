class AddIsDeprecatedToUserEmail < ActiveRecord::Migration
  def change
    add_column :user_emails, :is_deprecated, :boolean
  end
end
