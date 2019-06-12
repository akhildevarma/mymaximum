module V2
  class HospitalShortageSerializer < ActiveModel::Serializer
    attributes :title, :published_date

    def published_date
    	object.published_date.to_i
    end
  end
end
