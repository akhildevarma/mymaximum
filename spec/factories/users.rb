FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email }
    password { 'foobar' }
    password_confirmation { 'foobar' }
    do_not_text { true }
    account_activated_at { Time.now }

    trait :admin do
      administrator { Administrator.new }
    end

    trait :provider do
      provider do Provider.new(
        license_number: Forgery(:basic).number,
        licensing_state: 'GA',
        specialty: 'Primary Care'
      )
      end
    end

    trait :empty_provider do
      after(:create) do |user|
        provider = Provider.new
        provider.user = user
        provider.save(validate:false)
      end
    end

    trait :patient do
      patient { Patient.new }
    end

    trait :student do
      student { Student.new }
      invitation { FactoryGirl.create(:student_invitation) }
    end

    trait :with_profile do
      profile { FactoryGirl.build :profile }
    end

    trait :with_payment_account do
      after(:create) do |user, evaluator|
        payment_account = if user.provider? then :provider_payment_account else :payment_account end
        user.payment_account = FactoryGirl.create( payment_account, user: user )
        user.save!
      end
    end

    trait :with_billing_error do
      after(:create) do |user|
        if user.provider?
          payment_account = user.payment_account.as do |pa|
            pa.stripe_customer_token = nil
            pa.save(validate: false)
          end
        end
      end
    end

    trait :inactive do
      account_activated_at nil
    end

    trait :with_invitation do
      invitation { FactoryGirl.create(:invitation) }
    end

    factory :admin_user, traits: [:admin]
    factory :user_with_profile, traits: [:with_profile]
    factory :provider_user, traits: [:provider, :with_profile, :with_payment_account]
    factory :student_user, traits: [:student]
    factory :patient_user, traits: [:patient, :with_profile, :with_payment_account]
    factory :inactive_user, traits: [:inactive]
    factory :empty_provider_user, traits: [:empty_provider]
  end
end
