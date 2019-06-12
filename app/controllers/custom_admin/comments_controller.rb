class CustomAdmin::CommentsController < CustomAdmin::ApplicationController

  def index
    @comments = Comment.paginate(page: params[:page], per_page: 10).order(created_at: :desc)
  end

  def edit
    @comment  = Comment.find(params[:id])
  end

  def update
    @comment = Comment.find(params[:id])
    if @comment.update(comment_params)
      redirect_to custom_admin_comments_path(@comment), notice: I18n.t('comments.success')
    else
      render 'edit'
    end
  end

  private

   def comment_params
      params.require(:comment).permit(:id,:title, :body,:referenceable_id,:referenceable_type,:user_id,:deleted)
    end

end
