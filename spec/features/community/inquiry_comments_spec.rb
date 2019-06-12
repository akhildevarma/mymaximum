require 'feature_helper'

feature "Inquiry comments", :ignore do
  let!(:news) { create_list :published_inquiry, 5 }
  before :each do
    ApplicationController.any_instance.stub(:feature?) { true }
		@current_user = login_as_admin
		visit '/news'
	end
  let(:user) { create :user_with_profile }
  let!(:inquiry) { news.first }
  let!(:comment) { create :comment, user: user, referenceable: inquiry }
  let!(:comment_list) { create_list :comment, 5, user: user, parent_id: comment.id, referenceable: inquiry }

  scenario 'can see inquiry comments' do
  	el = page.first("#published_inquiry_#{inquiry.id}")
    expect(el).to_not be nil
    el.click
   	expect(page).to have_content 'Comment'
   	expect(page).to have_content comment_list.size + 1
   	comment_list.each {|_comment|
   		expect(page).to have_content _comment.body
   	}
  end

end
