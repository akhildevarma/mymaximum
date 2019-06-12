require 'rails_helper'

describe ApplicationHelper do
 let(:helpers) { ApplicationController.helpers }
 let(:asap_inquiries) {
   create_list :inquiry_with_assignee, 5, turnaround_time: 'asap', status: 'complete',created_at: Time.now, completed_at: Time.now + 1.hours
 }

 before {
  asap_inquiries.each { |inquiry|  inquiry.save! }
 }

  describe '#average_time' do
    context 'calculates average time in words' do
      let(:last_week_asap) {
        Inquiry.last_inquiries_by_timeframe(7,1)
      }

      it 'does calculates average turnaround_time' do
       expect(average_time(last_week_asap)).to eq('about 1 hour')
      end

      it 'does returns nil when empty array' do
       last_week_asap = []
       expect(average_time(last_week_asap)).to eq(nil)
      end

    end
  end

  describe '#minimum_time' do
    context 'calculates minimum_time in words' do
      let(:last_week_asap) {
        Inquiry.last_inquiries_by_timeframe(7,1)
      }

      it 'does calculates minimum_time turnaround_time' do
        expect(minimum_time(last_week_asap)).to eq('about 1 hour')
      end

      it 'does returns nil when empty array' do
        last_week_asap = []
        expect(minimum_time([])).to eq(nil)
      end
    end
  end

  describe '#maximum_time' do
    context 'calculates maximum_time in words' do
      let(:last_week_asap) {
        Inquiry.last_inquiries_by_timeframe(7,1)
      }

      it 'does calculates maximum_time turnaround_time' do
        expect(maximum_time(last_week_asap)).to eq('about 1 hour')
      end
      it 'does returns nil when empty array' do
        last_week_asap = []
        expect(maximum_time([])).to eq(nil)
      end
    end
  end

  describe '#comments_tree_for' do
    let(:user) { create :user_with_profile}
    let(:inquiry) { create(:inquiry_with_assignee) }
    let(:comment) { create :comment, user: user, referenceable: inquiry }
    let(:comment_list) { create_list :comment, 5, user: user, parent_id: comment.id, referenceable: inquiry }
    let(:active_comments) { Comment.active_comments(comment.id)}
    it 'renders shared comments partial' do
      helper.comments_tree_for(active_comments, 'comments/mail_comment')
    end
  end

end
