class CommentsJob < Struct.new(:comment_id)
  
  def perform
    if active_comments = Comment.active_comments(comment_id)
      CommentsMailer.reply_notification(active_comments,comment_id).deliver_now
      InquiryResponseMailer.community_activity(comment_id).deliver_now
    end
  end

end
