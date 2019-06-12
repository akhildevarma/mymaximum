FactoryGirl.define do
  factory :upload_user do
    email { Faker::Internet.email }
    first_name { Forgery(:name).first_name }
    last_name { Forgery(:name).last_name }
    name_suffix { Forgery(:name).title }
    company { Forgery(:name).company_name }
    city 'San Francisco'
    state 'CA'
    phone_number { Forgery(:address).phone }
    specialty { 'OBGYN' }
  end
end
