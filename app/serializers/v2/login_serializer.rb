module V2
  class LoginSerializer < ActiveModel::Serializer
  	attributes :access_token, :email, :expires_at
	  def expires_at
	    object.expires_at.to_i
	  end
  end
end
