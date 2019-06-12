FactoryGirl.define do
  factory :notification do
    user { FactoryGirl.create(:student_user) }
    referenceable {  FactoryGirl.create(:inquiry_with_assignee) }
    message { I18n.t("notifications.#{Notification::INACTIVE_LAST_3HOURS}") }
    sent_via { Notification::SMS }
    notification_type { Notification::INACTIVE_LAST_3HOURS }
  end
end
