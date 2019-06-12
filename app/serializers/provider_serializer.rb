class ProviderSerializer < ActiveModel::Serializer
  attributes :id, :specialty, :license_number, :licensing_state, :errors
end
