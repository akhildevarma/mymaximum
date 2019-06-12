class EmailListColumnChange < ActiveRecord::Migration
  def change
    rename_column :email_lists, :Group, :group
    EmailList.create(group: "SignupGroup")
  end
end
