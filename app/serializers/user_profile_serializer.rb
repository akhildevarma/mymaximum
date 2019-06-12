class UserProfileSerializer < ActiveModel::Serializer
  has_one :profile
  has_one :user
  has_one :provider

  attribute :is_admin

  def include_provider?
    object.user.provider?
  end

end
