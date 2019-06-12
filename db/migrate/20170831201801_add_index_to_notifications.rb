class AddIndexToNotifications < ActiveRecord::Migration
  def change
    add_index 'notifications', ['notification_type', 'sent_at'], name: 'index_notifications_on_notification_type_sent_at', using: :btree
  end
end
