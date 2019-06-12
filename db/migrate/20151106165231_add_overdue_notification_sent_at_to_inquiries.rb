class AddOverdueNotificationSentAtToInquiries < ActiveRecord::Migration
  def change
    add_column :inquiries, :overdue_notification_sent_at, :datetime
  end
end
