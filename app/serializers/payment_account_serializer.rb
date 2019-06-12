class PaymentAccountSerializer < ActiveModel::Serializer
  attributes :id,
    :user_id,
    :last_four_digits,
    :plan_id,
    :stripe_customer_token,
    :errors,
    :created_at,
    :updated_at,
    :coupon_code
end
