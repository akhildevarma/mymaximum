module V2
  class ErrorSerializer < ActiveModel::Serializer
    attributes :title, :detail, :id, :href, :code, :source, :links, :status, :meta
  end
end
