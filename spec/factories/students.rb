FactoryGirl.define do
  factory :student do
    user { create :user_with_profile }
    can_assign true
    is_alumn true
    is_active true
  end
end
