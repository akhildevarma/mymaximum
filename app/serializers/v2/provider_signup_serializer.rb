module V2
  class ProviderSignupSerializer < ActiveModel::Serializer
    attributes :id, :user, :provider, :profile

    def id
      object.user.id
    end

    def user
      V2::UserSerializer.new(object.user)
    end

    def provider
      V2::ProviderSerializer.new(object.provider)
    end

    def profile
      V2::ProfileSerializer.new(object.profile)
    end
  end
end
