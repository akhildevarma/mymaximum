module V2
  class TeamSerializer < ActiveModel::Serializer
  	attributes :name, :admin_email, :signup_url_path, :email_domain, :logo_medium_url, :logo_original_url

    def logo_medium_url
      object.logo.url(:medium)
    end

    def logo_original_url
      object.logo.url(:original)
    end
  end
end
