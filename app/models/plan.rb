class Plan < ActiveRecord::Base
  scope :a_la_carte, -> { find_by_name!('a_la_carte') }
  scope :provider_monthly, -> { find_by_name!('provider_monthly') }
  scope :provider_yearly, -> { find_by_name!('provider_yearly') }
  scope :provider_per_request, -> { find_by_name!('pay_per_request') }

  def self.provider_plans
    [provider_monthly, provider_yearly, provider_per_request]
  end

  def self.patient_plans
    [a_la_carte]
  end

  def self.plans_for_user_role(user)
    if user.provider?
      return self.provider_plans
    elsif user.patient?
      return self.patient_plans
    end
    []
  end
end
