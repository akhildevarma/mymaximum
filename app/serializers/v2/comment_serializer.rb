module V2
  class CommentSerializer < ActiveModel::Serializer
    attributes :id, :body, :deleted, :referenceable_type, :referenceable_id, :created_at, :parent_id

    def created_at
      object.created_at.to_i
    end
  end
end
