class Notification < ActiveRecord::Base
  include Notifiable
  belongs_to :user
  belongs_to :referenceable, polymorphic: true
  before_create :weekly_email_finished_update
  before_create :weekly_email_status_update
  after_create :notify

  INACTIVE_LAST_3HOURS   = 'inactive_for_last_3hours'
  ADD_TEAM_USER          = 'add_user'
  SMS                    = 'sms'
  EMAIL                  = 'email'
  SECOND_WELCOME         = 'second_welcome'
  THIRD_WELCOME          = 'third_welcome'
  FOURTH_WELCOME         = 'fourth_welcome'
  FOLLOW_UP_TEAM_USER    = 'follow_up_team_user'
  SIGNUP_AUTOMATE_EMAIL  = 'automate_emails'
  WHITELISTED_INQUIRY_METHODS = [:inactive_for_last_3hours] #We can add more in future
  SIGNUP_EMAIL_GROUP = 'SignupGroup'

  def self.send_inquiry_inactive_notification(type=INACTIVE_LAST_3HOURS,sent_via=SMS)
    message = I18n.t("notifications.#{type}")
    throw "Method missing or invalid inactivity :  #{type.to_sym} for Inquiry" unless WHITELISTED_INQUIRY_METHODS.include?(type.to_sym)

    if (inactive_inquiries =  Inquiry.send(type.to_sym))
      self.inquiry_notification(inactive_inquiries,message,sent_via,type)
    end
  end

  def self.inquiry_notification(inquiries=[],message,sent_via,type)
    inquiries.each do |inquiry|
      if self.sent_inquiry_notifications?(inquiry,sent_via).blank?
        create(user: inquiry.assignee, notification_type: type, referenceable: inquiry, sent_via: sent_via, message: message)
      end
    end
  end

  def self.send_response_text(inquiry)
    message = "Your InpharmD response is ready! Check it out here. #{ENV['APP_HOST_URL']}/inquiries/#{inquiry.id}"
    create(user: inquiry.submitter, notification_type: SMS, referenceable: inquiry, sent_via: SMS, message: message)
  end

  def self.sent_inquiry_notifications?(inquiry_id,sent_via)
    where("referenceable_type = 'Inquiry' and sent_via = ? and referenceable_id = ?",sent_via,inquiry_id)
  end

  def self.send_secondary_welcome!
    includes(:user)
    .where(referenceable_type: 'User', notification_type: SECOND_WELCOME, sent_at: nil)
    .where('created_at <= ?', Time.now - 1.day).each do |notification|
      if Inquiry.where(submitter: notification.user).count < 1
        SignupMailer.secondary_welcome(notification.user).deliver_now
      end
      notification.update_attribute(:sent_at, Time.now)
    end
  end

  # 1 week after secondary welcome email
  def self.send_third_welcome!
    includes(:user)
    .where("referenceable_type='User' and  notification_type=? and sent_at IS NOT NULL", SECOND_WELCOME)
    .where('sent_at <= ?', Time.now - 1.week).each do |notification|
      if Inquiry.where(submitter: notification.user).count < 1
        SignupMailer.third_welcome(notification.user).deliver_now
      end
      notification.update_attribute(:notification_type, THIRD_WELCOME)
    end
  end

  #1 month after creating account
  def self.send_fourth_welcome!
    includes(:user)
    .where("referenceable_type='User' and  notification_type=? and sent_at IS NOT NULL", THIRD_WELCOME)
    .where('created_at <= ?', Time.now - 1.month).each do |notification|
      if Inquiry.where(submitter: notification.user).count < 1
        notification_user = notification.user
        SignupMailer.fourth_welcome(notification_user).deliver_now
        begin
          n = Notification.new
          n.send_sms_notification(I18n.t('signup.fourth_welcome_text', name: notification_user.decorate.try(:name)), to: notification_user)
        rescue Exception => e
          logger.info "Failed text message #{e.message}"
        end
      end
      notification.update_attributes({notification_type: FOURTH_WELCOME, sent_at: Time.now})
    end
  end

  # 1 week after secondary welcome email
  def self.send_upload_user_second_welcome!
    includes(:user)
    .where("referenceable_type='User' and  notification_type=? and sent_at IS NOT NULL", ADD_TEAM_USER)
    .where('sent_at <= ?', Time.now - 2.week).each do |notification|
      if notification.user.requires_account_activation? && Inquiry.where(submitter: notification.user).count < 1
        AccountActivationMailer.second_team_activation(notification.user).deliver_now
      end
      notification.update_attribute(:notification_type, FOLLOW_UP_TEAM_USER)
    end
  end


  def notify
    if self.sent_via == SMS
      send_sms_notification(self.message, to: self.user)
    elsif ((self.sent_via == EMAIL) && (notification_type==ADD_TEAM_USER))
      AccountActivationMailer.add_team_activation(self.user).deliver_later
    end
  end

  def weekly_email_finished_update
    self.weekly_email_finished = 'false'
  end

  def weekly_email_status_update
    self.weekly_email_status = 1
  end

  def self.weekly_emails
    email_group = EmailList.find_by_group(SIGNUP_EMAIL_GROUP)
    weekly = Notification.where("referenceable_type='User' and  weekly_email_finished ='false' and weekly_email_status >=1")
    (1...5).each{|weeknumber|
      weekly.where('created_at <= ? and weekly_email_status = ?', Time.now - weeknumber.week, weeknumber).each{|notification|
        unscriber_list = UnscriberList.find_by(email: notification.user.email, group_id: email_group)
        if unscriber_list.nil?
          SignupMailer.send(:"signup_automated_email_#{weeknumber}", notification.user, email_group).deliver_later
          notification.update_attributes(notification_type: SIGNUP_AUTOMATE_EMAIL, weekly_email_status: weeknumber + 1)
          notification.update_attributes(weekly_email_finished: 'true') if (weeknumber == 4)
        end
      }
    }
  end
end
