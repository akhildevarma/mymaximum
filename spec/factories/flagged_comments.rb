FactoryGirl.define do
  factory :flagged_comment do
  	user { create :user_with_profile }
  	comment { create :comment}
  end
end
