FactoryGirl.define do
  factory :invitation do
    email { Forgery(:email).address }
    invitation_type Invitation::GENERAL_INVITATION_TYPE

    trait :student do
      invitation_type Invitation::STUDENT_INVITATION_TYPE
    end

    factory :student_invitation, traits: [:student]
  end
end
