FactoryGirl.define do
  factory :profile do
    first_name { Forgery(:name).first_name }
    last_name { Forgery(:name).last_name }
    name_title { Forgery(:name).title }
    company { Forgery(:name).company_name }
    city 'San Francisco'
    state 'CA'
    phone_number { Forgery(:address).phone }
  end
end
