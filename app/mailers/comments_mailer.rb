class CommentsMailer < ApplicationMailer

	def reply_notification(comments,comment_id)
		@inquiry = Comment.find(comment_id).referenceable
		emails = Comment.parse_emails(comments)
		@comments = comments
		unless emails.blank?
	  	mail(to: emails, subject: I18n.t('comments.reply_notification_subject',question: @inquiry.question))
	  end
	end

end
