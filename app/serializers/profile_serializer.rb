class ProfileSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :middle_name, :last_name, :full_name, :name_suffix, :name_title, :company, :city, :state, :phone_number, :errors
end
