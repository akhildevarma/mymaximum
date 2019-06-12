class PreventMailInterceptor
  def self.delivering_email(message)
    unless deliver?(message)
      message.perform_deliveries = false
      Rails.logger.debug "Interceptor prevented sending mail #{message.inspect}!"
    end
    message.to = set_primary_email(message)
  end

  def self.deliver?(message)
    return true if message[:mail_type].present? && allowed_mail_types.include?(message[:mail_type].value)
    message.to.any? { |recipient| user = User.where(email: recipient).first; (user.blank? || user.is_active?) }
  end

  def self.allowed_mail_types
    ['password_reset', 'invitation']
  end

  def self.set_primary_email(message)
    to_emails = message.to.inject([]) do |result, recipient| 
      user = User.where(email: recipient).first
      email = (user && user.emails.where(is_primary: true).first.try(:email) rescue nil)
      result << (email || recipient)
    end
    Rails.logger.debug "to_emails #{to_emails.inspect}!"
    to_emails.compact
  end
end
