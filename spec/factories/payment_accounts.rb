FactoryGirl.define do
  factory :payment_account do
    plan { FactoryGirl.create(:a_la_carte) }
    stripe_customer_token 'cus_2boUgOUX1650rT'
    last_four_digits 4242

    trait :provider do
      plan { FactoryGirl.create(:provider_per_request) }
    end

    factory :provider_payment_account, traits: [:provider]
  end
end
