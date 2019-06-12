  module V2
    class Comments < Grape::API
      helpers ApiHelpers::CommentHelper
      before do
        error!("Unauthorized", 401) unless authenticated
      end

      desc 'Create a comment'
      params do
        requires :comment, type: Hash do
          optional :parent_id, type: Integer, desc: "Parent's comment id"
          requires :user_id, type: Integer, desc: 'Id of the current logged in user'
          requires :body, type: String, desc: 'Comment body content'
          requires :referenceable_id, type: Integer, desc: 'Referenceable Id like id of inquiry/user etc'
          requires :referenceable_type, type: String, desc: 'Type of the referenceable object like Inquiry/User'
        end
      end
      post '/comments'  do
        validate_referenceable
        comment = process_comment    
        if comment.save
          presenter(comment, V2::CommentSerializer)
        else
          present comment.errors
        end
      end

      desc 'Edit a comment'
      params do
        requires :comment, type: Hash do
          requires :id, type: Integer, desc: 'Comment ID'
          requires :body, type: String, desc: "Comment's body"
        end
      end
      put '/comments' do
        resource(Comment,params[:comment][:id])
        if @resource.update_attributes(declared( params )[:comment])
          presenter(@resource, V2::CommentSerializer)
        else
          present @resource.errors
        end
      end

      desc 'Delete a comment'
      params do
        requires :comment, type: Hash do
          requires :id, type: Integer, desc: 'Comment ID'
        end
      end
      delete '/comments' do
        resource(Comment,params[:comment][:id])
        if @resource.update_attribute(:deleted, true)
          presenter(@resource, V2::CommentSerializer)
        else
          present @resource.errors
        end
      end

      desc 'Flagging/Report abused comment'
      params do
        requires :comment, type: Hash do
          requires :id, type: Integer, desc: 'Comment ID'
          requires :user_id, type: Integer, desc: 'Reporter user id'
        end
      end
      put '/comments/flag' do
        resource(Comment,params[:comment][:id])
        flagger = FlaggedComment.create(user_id: params[:comment][:user_id], comment: @resource)
        if flagger
          presenter(@resource, V2::CommentSerializer)
        else
          present flagger.errors
        end
      end

      desc 'Available comments for specific Inquiry'
      params do
        requires :inquiry_id, type: Integer, desc: 'Inquiry Id'
        requires :user_id, type: Integer, desc: 'User Id'
      end
      get '/comments/list' do
        resource(Inquiry,params[:inquiry_id])    
        current_user ||= User.find_by_id params[:user_id]
        comments = @resource.active_comments(current_user)
        present data: { count: comments.count, comments: custom_json_hash_tree(comments) }, jsonapi: { version: ActiveModelSerializers.config.jsonapi_version }
    end

    end
  end
