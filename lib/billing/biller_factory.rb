module Billing
  class BillerFactory
    def self.create(payment_account)
      raise ArgumentError, 'payment account must not be nil' unless payment_account.present?
      self.implementation(payment_account.plan).new(payment_account)
    end

    def self.implementation(plan)
      case plan.name.to_sym
      when :a_la_carte, :provider_per_request, :pay_per_request
        ALaCarteBiller
      when :provider_monthly, :provider_yearly, :patient_monthly, :patient_yearly
        SubscriptionBiller
      else
        raise ArgumentError, "unknown plan: #{plan}"
      end
    end
  end
end
