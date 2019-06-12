class CustomAdmin::FlaggedCommentsController < CustomAdmin::ApplicationController
  before_action :set_flagged_comment, only: [:edit, :update, :destroy]

  def index
    @flagged_comments = FlaggedComment.paginate(page: params[:page], per_page: 10).order(created_at: :desc)
  end

  def edit
  end

  def update
    if @flagged_comment.update(flagged_comment_params)
      redirect_to custom_admin_flagged_comments_path(@flagged_comment), notice: I18n.t('comments.success')
    else
      render 'edit'
    end
  end

  def destroy
    @flagged_comment.destroy!
    redirect_to flagged_comment_users_path(comment_id: @flagged_comment.comment_id), notice: 'Deleted successfully'
  end

  def users
    @flagged_comments = FlaggedComment.where({comment_id: params[:comment_id]}).paginate(page: params[:page], per_page: 10).order(created_at: :desc)
  end

  private

    def flagged_comment_params
      params.require(:flagged_comment).permit(:id,:user_id,:comment_id)
    end

     def set_flagged_comment
      @flagged_comment = FlaggedComment.find params[:id]
    end

end
