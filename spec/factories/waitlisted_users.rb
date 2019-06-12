FactoryGirl.define do
  factory :waitlisted_user do
    email { Faker::Internet.email }

    trait :provider do
      provider { true }
    end

    trait :patient do
      provider { false }
    end

    factory :waitlisted_provider, traits: [:provider]
    factory :waitlisted_patient, traits: [:patient]
  end
end
