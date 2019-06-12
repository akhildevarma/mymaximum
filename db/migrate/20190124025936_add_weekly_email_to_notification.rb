class AddWeeklyEmailToNotification < ActiveRecord::Migration
  def change
    add_column :notifications, :weekly_email_finished, :boolean
    add_column :notifications, :weekly_email_status, :integer
  end
end
