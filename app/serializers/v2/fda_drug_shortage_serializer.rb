module V2
  class FdaDrugShortageSerializer < ActiveModel::Serializer
    attributes :title, :description, :link, :published_date

    def published_date
      object.published_date.to_i
    end
  end
end
