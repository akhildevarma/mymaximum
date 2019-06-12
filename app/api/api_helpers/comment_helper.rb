module ApiHelpers
  module CommentHelper

    def validate_referenceable
      referenceable_type = params[:comment][:referenceable_type].capitalize
      klass = referenceable_type.constantize rescue false
      if klass
        unless @refereneable = klass.where(id: params[:comment][:referenceable_id]).first
          render_exceptions({id: params[:comment][:referenceable_id], type: 'RecordNotFound'}, 404)
        end
      else
        render_exceptions({id: params[:comment][:referenceable_type], type: 'RecordNotFound'}, 400)
      end
    end

    def custom_json_hash_tree(comments)
      comments.map do |comment, nested_comments|
        { body: comment.body,name: comment.user.try(:name), created_at: comment.created_at.to_i,responses: nested_comments.size > 0 ? custom_json_hash_tree(nested_comments) : [] }    
      end
    end

    def resource(type,id)
      @resource = type.find_by_id(id)
      error!( error_presenter( JSONAPI::Exceptions::RecordNotFound.new(params[:id]).errors ), 404 ) unless @resource
    end

    def process_comment
      if params[:comment][:parent_id].to_i > 0
        parent = Comment.find_by_id(params[:comment].delete(:parent_id))
        comment = parent.children.build(declared( params )[:comment])
        comment.referenceable_id = parent.referenceable_id
        comment.referenceable_type = parent.referenceable_type
      else
        comment = Comment.new(declared( params )[:comment])
      end
      comment.deleted = false
      comment
    end

  end
end
