desc "This task is called by the Heroku scheduler add-on"

task :inquiry_send_response_overdue_reminders => :environment do
  Inquiry.send_response_overdue_reminders
end

task :inquiry_send_text_notification => :environment do
  Notification.send_inquiry_inactive_notification
end

task send_secondary_welcome: :environment do
  Notification.send_secondary_welcome!
end

task send_third_welcome: :environment do
  Notification.send_third_welcome!
end

task send_fourth_welcome: :environment do
  Notification.send_fourth_welcome!
end

task send_feedback_email: :environment do
  SurveyResponse.send_feedback_email(10)
end

task reload_drug_shortages: :environment do
  FdaDrugShortage.reload
end

task personal_email_after_one_month: :environment do
  User.personal_email
end

task team_activation_after_two_weeks: :environment do
  Notification.send_upload_user_second_welcome!
end

task user_signup_remainder: :environment do
  SignupTracker.singup_tracker_reminder
end

task signup_users_automate_email: :environment do
  Notification.weekly_emails
end

task inquiry_response_overtime: :environment do
  Inquiry.inquiry_response_status
end
