module V2
  class DocumentSerializer < ActiveModel::Serializer
    attributes :user_id, :url, :created_at, :user_name, :file_file_size, :file_file_name, :description

    def url
      object.file.expiring_url(1000)
    end

    def created_at
      object.created_at.to_i
    end

    def user_name
      object.try(:user).full_name_or_email
    end

  end
end
