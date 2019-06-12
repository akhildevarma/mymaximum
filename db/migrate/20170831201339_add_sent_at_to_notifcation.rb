class AddSentAtToNotifcation < ActiveRecord::Migration
  def change
    add_column :notifications, :sent_at, :datetime, null: true
  end
end
