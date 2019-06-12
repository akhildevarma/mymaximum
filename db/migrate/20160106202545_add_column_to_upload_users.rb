class AddColumnToUploadUsers < ActiveRecord::Migration
  def change
     add_column :upload_users, :message, :string
  end
end
