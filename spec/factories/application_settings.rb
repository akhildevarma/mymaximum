FactoryGirl.define do
  factory :application_settings do
    require_general_invitations { false }
    allow_promo_code { true }
  end
end
