module Notifiable
  extend ActiveSupport::Concern

  included do
  end

  module ClassMethods
  end

  def notify!(notification_name)
    method_name = "notify_#{notification_name}".to_sym
    throw "Method missing: #{method_name}" unless self.class.instance_methods(false).include?(method_name)
    send method_name
    true
  end

   def send_sms_notification(message_body, to:)
    recipient_number = to.try(:profile).try(:phone_number)
    return false unless recipient_number
    from = ENV['TWILIO_PHONE_NUMBER']
    to = "+1#{recipient_number}"
    if message_body.include?('Your InpharmD response is ready!')
      body = message_body
    else
      body = "InpharmD: #{["\"",message_body,"\""].join}"
    end
    body = 
    twilio_messages_client.create(
      from: from, to: to,
      body: body
    )
  end

  private
  def twilio_messages_client
    Twilio::REST::Client.new(ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN']).account.sms.messages
  end
end
