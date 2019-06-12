object @patient_signup => nil

child :user do
  attributes :id, :email, :do_not_text, :promo_code
end

child :profile do
  attributes :id, :user_id, :first_name, :middle_name, :last_name,
             :name_suffix, :name_title, :company, :city, :state,
             :phone_number
end

child :patient, if: lambda { |up| up.patient.present? } do
  attributes :id, :user_id
end

node(:errors) do
  node(:patient_signup) { @patient_signup.errors }
  node(:user) { @patient_signup.user.errors }
  node(:patient) { @patient_signup.patient.errors }
  node(:profile) { @patient_signup.profile.errors }
end
