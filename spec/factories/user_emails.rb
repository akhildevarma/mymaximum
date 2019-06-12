FactoryGirl.define do
  factory :user_email, class: User::Email do
    email { Faker::Internet.email }
    user
  end
end
