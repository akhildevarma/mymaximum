module V2
  class HospitalDrugSerializer < ActiveModel::Serializer
    attributes :title, :team_id, :updated_at

    def updated_at
      object.updated_at.to_i
    end
  end
end