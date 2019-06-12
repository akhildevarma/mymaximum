require 'rails_helper'

describe Inquiry do
  # Class Methods
  describe '.send_response_overdue_reminders' do
    before { create_list :inquiry_with_assignee, 10, turnaround_time: 'a_week' }
    subject { Inquiry.send_response_overdue_reminders }
    it 'does not send email more than once' do
      expect do
        Timecop.travel(Time.now + 1.day) { subject; subject }
      end.to change { ActionMailer::Base.deliveries.count }.by(10)
    end
    context 'not overdue' do
      its(:count) { is_expected.to eq 0 }
    end
    context 'asap overdue' do
      before do
        create_list :inquiry_with_assignee, 5, turnaround_time: 'asap'
        Timecop.travel(Time.now + 5.hours)
      end
      its(:count) { is_expected.to eq 5 }
      after { Timecop.return }
    end
    context 'default overdue' do
      before { Timecop.travel(Time.now + 1.day) }
      its(:count) { is_expected.to eq 10 }
      after { Timecop.return }
    end

  end

  describe '.to_csv' do
    it 'uses specified header_names' do
      header_names = ['Email', 'First Name', 'Last Name', 'Question', 'Inquiry State', 'Created At', 'Turnaround Time', 'User Received At', 'Last Updated At'].join(',')
      output_csv = Inquiry.to_csv
      expect(output_csv).to include header_names
    end
  end

  context 'with an assignee' do
    let(:inquiry) { FactoryGirl.create(:inquiry_with_assignee) }

    it 'removes the assignee when the status is changed to Review' do
      inquiry.status = :review
      inquiry.save
      expect(inquiry.assignee).to be_nil
    end

    it 'does not remove assignee when the status is blank' do
      inquiry.status = ''
      inquiry.save
      expect(inquiry.assignee).not_to be_nil
    end
  end

  context 'with summary table includes responder' do
    let(:inquiry) { FactoryGirl.create(:inquiry_with_table) }

    it 'contains responders email' do
      expect(inquiry.summary_tables[0].responder.email).not_to be_nil
    end
  end

  describe '#save_and_bill' do
    let(:inquiry) { FactoryGirl.build(:inquiry, submitter: submitter) }
    let(:biller) { double('Biller') }
    before do
      allow(Billing::BillerFactory).to receive(:create) { biller }
    end
    context 'with a provider submitter' do
      let(:submitter) { FactoryGirl.create(:provider_user) }
      it 'bills the submitter' do
        expect(biller).to receive(:process_inquiry_charge).and_return(true)
        allow(submitter.payment_account).to receive(:trialing?) { false }
        inquiry.save_and_bill
      end
    end

    context 'with an administrator submitter' do
      let(:submitter) { FactoryGirl.create(:admin_user) }
      it 'does not bill the submitter' do
        expect(biller).not_to receive(:process_inquiry_charge)
        inquiry.save_and_bill
      end
    end
  end

  describe '#old_response_format' do
    let(:response_text) { 'Response!' }
    let(:inquiry) { FactoryGirl.create(:inquiry_with_assignee, custom_response_text: response_text) }
    let(:lit_count) { inquiry.summary_tables.count } # returns 2 (Stubbed in `before`)
    subject { inquiry.old_response_format }

    it { is_expected.to include response_text }
    context 'no custom response text' do
      let(:response_text) { nil }
      it { is_expected.to eq '' }
    end
    context 'with background' do
      let(:background_text) { 'Test background text' }
      let(:inquiry) { FactoryGirl.create(:inquiry_with_assignee, custom_response_text: response_text, background: background_text) }
      it { is_expected.to eq "#{response_text}\n\n\nBACKGROUND\n\n#{background_text}" }
      context 'witho no custom_response_text' do
        let(:response_text) { nil }
        it { is_expected.to eq "BACKGROUND\n\n#{background_text}" }
      end
    end
  end

  describe '.per_team_last_30' do
    let(:team) { create :team, :with_5_members, name: 'Team Name' }
    before { create_list :inquiry, 30, submitter: team.users.first }
    it 'works' do
      expect(Inquiry.per_team_last_30).to eq({ team_name: { total_inquiries: 30, inquiries_per_member: 6 } })
    end
  end

  describe '.per_user_last_30' do
    let(:users) { create_list :user, 10}
    before { create_list :inquiry, 30, submitter: users.first }
    it 'works' do
      expect(Inquiry.per_user_last_30).to eq 3
    end
  end

  describe '.last_inquiries_by_timeframe' do
    let(:created_at) { Time.now }
    let(:updated_at) { Time.now + 23.hours }
    let(:inquiry) { FactoryGirl.create(:inquiry_with_assignee, turnaround_time: 'asap',status: 'complete', created_at: created_at, updated_at: updated_at,completed_at: updated_at ) }
    it 'does have last weeks asap inquiries difference' do
      inquiry.save
      expect(Inquiry.last_inquiries_by_timeframe(7,1)).to eq ([(updated_at - created_at).round])
    end
  end

  describe '.last_all_inquiries_except_asap' do
    let(:created_at) { Time.now }
    let(:updated_at) { Time.now + 2.days }
    let(:inquiry) { FactoryGirl.create(:inquiry_with_assignee, turnaround_time: 'a_week',status: 'complete', created_at: created_at, updated_at: updated_at, completed_at: updated_at) }
    it 'does have last weeks a week  inquiries difference' do
      inquiry.save
      expect(Inquiry.last_all_inquiries_except_asap(7)).to eq ([(updated_at - created_at).round])
    end
  end

  describe '.all_completed_inquiries' do

    let(:created_at) { Time.now }
    let(:updated_at) { Time.now + 2.days }
    let(:inquiry) { FactoryGirl.create(:inquiry_with_assignee, turnaround_time: 'asap',status: 'response_formulation', created_at: created_at, updated_at: updated_at,completed_at: updated_at ) }

    with_versioning do
      it 'within a `with_versioning` block it will be turned on' do
        expect(PaperTrail).to be_enabled
      end
    end

    it 'does have versions history', versioning: true do
      inquiry.save
      expect(inquiry.versions.last.item_id).to eq (inquiry.id)
    end

    it 'does have versions and completed inquiries', versioning: true do
      inquiry.save
      inquiry.status = 'complete'
      inquiry.save
      expect(inquiry.versions.count).to eq(2)
      expect(Inquiry.all_completed_inquiries.last[:version]).to eq (inquiry.versions.last)
      expect(Inquiry.all_completed_inquiries.last[:inquiry]).to eq (inquiry)
    end
  end

   describe '.completed_inquiries_by_turnarround' do
    let(:created_at) { Time.now }
    let(:completed_at) { Time.now + 23.hours }
    let(:inquiry) { FactoryGirl.create(:inquiry_with_assignee, turnaround_time: 'asap',status: 'complete', created_at: created_at, completed_at: completed_at ) }
    it 'does have last weeks asap inquiries' do
      inquiry.save
      expect(Inquiry.completed_inquiries_by_turnarround(7,1)).to eq ([inquiry])
    end
  end

  describe '#active_comments' do
    let(:user) { create :user_with_profile}
    let(:inquiry) { create(:inquiry_with_assignee) }
    let!(:comment) { create :comment, user: user, referenceable: inquiry }
    let!(:comment_list) { create_list :comment, 5, user: user, parent_id: comment.id, referenceable: inquiry }
    let!(:flagged_comment) { create :flagged_comment, user: user, comment: comment_list.first }

    context 'does not have any flagged comments' do
      it 'does returns active comments' do
        expect(inquiry.active_comments(user).first[0]).to eq(comment)
      end
    end
    context 'does  have any flagged comments' do
      it 'does returns active comments without flagged comments' do
        active_comments = inquiry.active_comments(user)
        nested_comments = active_comments.map {|comment,nested_comment| nested_comment }
        expect(active_comments).to_not eq(nil)
        expect(nested_comments).to_not eq(nil)
      end
    end
  end

  describe '.slug' do
    let(:inquiry) { create(:inquiry_with_assignee) }
    it 'does have slug - paramaterized url' do
      expect(inquiry.slug).to_not eq(nil)
      expect(inquiry.slug).to eq(inquiry.title.parameterize)
    end
  end
end
