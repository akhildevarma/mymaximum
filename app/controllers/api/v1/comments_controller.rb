class API::V1::CommentsController < ApplicationController
  respond_to :json

  before_filter :require_user
  before_action :set_comment, only: [:flag, :update, :destroy]

  # def index
  #   @comments = Comment.hash_tree
  # end
  #
  # def new
  #   @comment = Comment.new(parent_id: params[:parent_id])
  # end
  #
  # def create
  #   if params[:comment][:parent_id].to_i > 0
  #     parent = Comment.find_by_id(params[:comment].delete(:parent_id))
  #     @comment = parent.children.build(comment_params)
  #     @comment.referenceable_id = parent.referenceable_id
  #     @comment.referenceable_type = parent.referenceable_type
  #   else
  #     @comment = Comment.new(comment_params)
  #   end
  #
  #   @comment.user = current_user if current_user.present?
  #   @comment.deleted = false
  #   if @comment.save
  #   	@inquiry = @comment.referenceable
	#   end
  #   @comment
  # end

  def update
  	@comment.update_attributes(comment_params)
  	@inquiry = @comment.referenceable
  	respond_to do |format|
	    format.json { respond_with_bip(@comment) }
	  end
  end

  def flag
  	FlaggedComment.create(user: current_user, comment: @comment)
  	@inquiry = @comment.referenceable
  	head :no_content
  end

  # def descendants
  #   @descendants_comments = Comment.descendant_comments(@comment.id,current_user.id)
  #   respond_to do |format|
  #     format.js { render 'shared/descendant_comments' }
  #   end
  # end
  #
  def destroy
    @comment.update_attribute(:deleted, true)
    @inquiry = @comment.referenceable
    head :no_content
  end

  private

    def comment_params
      params.require(:comment).permit(:title, :body,:referenceable_id,:referenceable_type,:redirect_path,:parent_id)
    end

    def set_comment
    	@comment = Comment.find params[:id]
    end
end
