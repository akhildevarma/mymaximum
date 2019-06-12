class UserSerializer < ActiveModel::Serializer
  attributes :id, :role, :email, :errors
end
