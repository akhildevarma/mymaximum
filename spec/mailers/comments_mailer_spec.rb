require 'rails_helper'

describe CommentsMailer do
	describe '#reply_notification' do
		let(:user) { create :user_with_profile}
		let(:inquiry) { create(:inquiry_with_assignee) }
  	let!(:comment) { create :comment, user: user, referenceable: inquiry }
  	let!(:comment_list) { create_list :comment, 5, user: user, parent_id: comment.id, referenceable: inquiry }
  	let!(:active_comments) { Comment.active_comments(comment.id)}
  	let(:mail) { CommentsMailer.reply_notification(active_comments, comment.id) }
		subject { mail }

		it { is_expected.to_not be nil }
		its(:subject) { is_expected.to eq I18n.t('comments.reply_notification_subject',question: inquiry.question) }

		it 'renders the receiver email' do
      expect(mail.to).to eql([user.email])
    end

    it 'renders the sender email' do
      mail_from = mail.message[:from].value
      expect(mail_from).to eql("\"InpharmD™\" <support@inpharmd.com>")
    end

    it 'body renders commentator name' do
      expect(mail.html_part.body).to match(user.profile.decorate.full_name)
    end

	end
end
