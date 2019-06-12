FactoryGirl.define do
  factory :team do
    name { Faker::Company.name.humanize }
    hidden false
    admin_email { Faker::Internet.email }
    email_domain { admin_email.split('@').last }
    sequence(:signup_url_path) { |n| "test-" + Array.new(5+n){[*"a".."z"].sample}.join + "-signup-url-path" }
    trait :with_5_members do
      after(:create)  { |team| create_list(:empty_provider_user, 5, team_id: team.id, last_active_at: Time.now) }
    end

  end

end
