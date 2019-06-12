FactoryGirl.define do
  factory :plan do
    initialize_with { Plan.where(name: name).first_or_create }
    factory :a_la_carte, class: Plan do
      name { 'a_la_carte' }
      price_in_cents { 0 }
      interval { 'week' }
      description { 'Pay per request' }
    end

    factory :provider_monthly, class: Plan do
      name { 'provider_monthly' }
      price_in_cents { 2499 }
      interval { 'month' }
      description { 'Unlimited monthly' }
    end

    factory :provider_yearly, class: Plan do
      name { 'provider_yearly' }
      price_in_cents { 24999 }
      interval { 'year' }
      description { 'Unlimited yearly' }
    end

    factory :provider_per_request, class: Plan do
      name { 'pay_per_request' }
      price_in_cents { 0 }
      interval { 'week' }
      description { 'Provider pay per request' }
    end
  end
end
