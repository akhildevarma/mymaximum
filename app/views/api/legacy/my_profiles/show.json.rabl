object @user_profile => nil

attributes :is_admin

child :user do
  attributes :id, :email, :do_not_text, :promo_code
end

child :profile do
  attributes :id, :user_id, :first_name, :middle_name, :last_name,
             :name_suffix, :name_title, :company, :city, :state,
             :phone_number
end

child :provider, if: lambda { |up| up.provider.present? } do
  attributes :id, :user_id, :license_number, :licensing_state,
             :specialty, :verified
end
