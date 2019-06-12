require 'rails_helper'
RSpec.describe Comment, type: :model do
	let(:user) { create :user_with_profile}
	let(:inquiry) { create(:inquiry_with_assignee) }
  let!(:comment) { create :comment, user: user, referenceable: inquiry }
  let!(:comment_list) { create_list :comment, 5, user: user, parent_id: comment.id, referenceable: inquiry }
  let!(:flagged_comment) { create :flagged_comment, user: user, comment: comment_list.first }
  
  describe '#active_comments' do
  	context 'does not have any flagged comments' do
	  	it 'does returns active comments' do
	  		expect(Comment.active_comments(comment_list.last.id).first[0]).to eq(comment)
	  	end
	  end
	  context 'does  have any flagged comments' do
	  	it 'does returns active comments without flagged comments' do
	  		active_comments = Comment.active_comments(comment_list.first.id)
	  		nested_comments = active_comments.map {|comment,nested_comment| nested_comment }
	  		expect(active_comments).to_not eq(nil)
	  		expect(nested_comments).to eq([{}])
	  	end
	  end
  end

  describe '#parse_emails' do
  	let!(:comments)	{ Comment.active_comments(comment_list.last.id)} 	
  	it 'does returns list of emails' do
  		expect(Comment.parse_emails(comments)).to eq([user.email])
  	end
  end

  describe '#descendant_comments' do
  	context 'does not have any flagged comments' do
	  	it 'does returns descendant comments' do
	  		expect(Comment.descendant_comments(comment_list.last.id, user.id).first[0]).to eq(comment_list.last)
	  	end
	  end
	  context 'does have flagged comments' do
	  	it 'does returns descendant comments without flagged comments for a user' do
	  		descendant_comments = Comment.descendant_comments(comment_list.first.id, user.id)
	  		nested_comments = descendant_comments.map {|comment,nested_comment| nested_comment }
	  		expect(descendant_comments).to_not eq(nil)
	  		expect(nested_comments).to eq([])
	  	end
	  end
  end
end
