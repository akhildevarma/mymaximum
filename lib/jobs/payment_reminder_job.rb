class PaymentReminderJob < Struct.new(:provider_id)
  def perform
    provider = Provider.find(provider_id)
    if provider.user
      PaymentReminderMailer.add_payment_reminder(provider.user).deliver_later unless provider.user.always_exempt_from_billing
    end
  rescue ActiveRecord::RecordNotFound => e
    Rails.logger.debug "Provider with id #{provider_id} does not exist."
    NewRelicRemote.report(e)
  end
end
