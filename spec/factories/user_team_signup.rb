FactoryGirl.define do
  factory :user_team_signup, class: User::TeamSignup do
    email_username 'john.willis'
    team
    user { attributes_for(:user) }
    signup_url_path { Faker::Company.name.parameterize }
    accept_team_of_service_and_privacy_policy 0
  end
end
