module V2
  class ProviderSerializer < ActiveModel::Serializer
    attributes :id, :specialty, :license_number, :licensing_state

    def specialty
      object.specialty || ''
    end
  end
end
