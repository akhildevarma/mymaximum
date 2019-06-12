module V2
  class ProfileSerializer < ActiveModel::Serializer
    attributes :id, :first_name,:last_name,:phone_number

    def phone_number
      object.phone_number || ''
    end
  end
end
