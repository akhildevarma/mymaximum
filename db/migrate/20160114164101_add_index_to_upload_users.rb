class AddIndexToUploadUsers < ActiveRecord::Migration
  def change
     add_index "upload_users", ["status"], name: "index_upload_users_on_status", using: :btree
     add_index "upload_users", ["team_id"], name: "index_upload_users_on_team_id", using: :btree
  end
end
