FactoryGirl.define do
  factory :provider_signup do
    initialize_with do
      new(
        user: { email: 'coolguy@provider.biz',
          password: 'foobar',
          password_confirmation: 'foobar'
        },
        profile: {
          first_name: 'Guy',
          last_name: 'Cool',
          name_title: 'Doctorman',
          city: 'Atlanta',
          state: 'GA',
          phone_number: '0009998765' },
        provider: {  license_number: '098382942',
          licensing_state: 'GA' },
        payment_account: {
          plan_id: 2,
          stripe_card_token: 'fakey_1234',
          last_four_digits: '1234'
        },
        accept_terms_of_service: 1
      )
    end

    trait :with_errors do
      accept_terms_of_service 0
      after(:build) do |provider_signup|
        provider_signup.user = {
          password: 'foobar',
          password_confirmation: 'not matching'
        }
        provider_signup.profile = {
          first_name: '',
          last_name: ''
        }
        provider_signup.accept_terms_of_service = 0
      end
    end
    factory :provider_signup_with_errors, traits: [:with_errors]
  end
end
