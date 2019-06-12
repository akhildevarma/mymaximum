require 'rails_helper'

describe CustomAdmin::DashboardController do
  let(:dashboard_controller) { CustomAdmin::DashboardController.new }
  before :each do
    login_as_admin
  end
  describe 'GET index' do
    it 'assigns' do
      get :index
      expect(assigns(:inquiry)).to eq(
        total: Inquiry.count,
        new_today: Inquiry.new_today.count,
        recent: Inquiry.order(created_at: :desc).limit(5),
        per_user_last_30: Inquiry.per_user_last_30,
        per_team_last_30: Inquiry.per_team_last_30,
        last_week_asap: Inquiry.last_inquiries_by_timeframe(7,1),
        last_month_asap: Inquiry.last_inquiries_by_timeframe(30,1),
        last_year_asap: Inquiry.last_inquiries_by_timeframe(365,1),
        last_week_all: Inquiry.last_all_inquiries_except_asap(7),
        last_month_all: Inquiry.last_all_inquiries_except_asap(30),
        last_year_all: Inquiry.last_all_inquiries_except_asap(365)
      )
      expect(assigns(:topic_search)).to eq(
        total: TopicSearch.count,
        recent: TopicSearch.order(created_at: :desc).limit(5)
      )
      expect(assigns(:student)).to eq(
        per_student: dashboard_controller.send(:inquiries_per_student)
      )

      expect(assigns(:users)).to eq(
        total: User.count,
        active_today: User.active_today.count,
        active_last_30: User.active_last_30.count,
        by_inquiries_count: User.by_inquiries_count,
        active_last_week: User.active_last_week.count,
        registered_last_week: User.registered_last_week.count
      )
    end

    it 'renders the index template' do
      get :index
      expect(response).to render_template('index')
    end
  end

  describe '#calculate_inquiry_percentage' do
    let(:created_at) { Time.now }
    let(:success_delivery_inquiry) { FactoryGirl.create(:inquiry_with_assignee, turnaround_time: 'asap',status: 'complete', created_at: created_at, completed_at: created_at + 23.hours ) }
    let(:failure_delivery_inquiry) { FactoryGirl.create(:inquiry_with_assignee, turnaround_time: 'asap',status: 'complete', created_at: created_at, completed_at: created_at + 2.days ) }

    it 'does have success and failure percentages' do
      success_delivery_inquiry.save
      failure_delivery_inquiry.save
      expect(dashboard_controller.send(:calculate_inquiry_percentage, 1,1.day,7)).to include({success_percentage: 50.0, failure_percentage: 50.0})
    end
  end

  describe '#inquiries_per_student' do
    let(:created_at) { Time.now }
    let(:success_delivery_inquiry) { FactoryGirl.create(:inquiry_with_assignee, turnaround_time: 'asap',status: 'response_formulation', created_at: created_at, completed_at: created_at + 23.hours ) }
    let(:failure_delivery_inquiry) { FactoryGirl.create(:inquiry_with_assignee, turnaround_time: 'asap',status: 'response_formulation', created_at: created_at, completed_at: created_at + 2.days ) }
    before {
      success_delivery_inquiry.save
      success_delivery_inquiry.save
    }
    it 'does have inquiries_per_student', versioning: true do
      success_delivery_inquiry.status = 'complete'
      failure_delivery_inquiry.status = 'complete'
      success_delivery_inquiry.save
      failure_delivery_inquiry.save
      inquiries_per_student = dashboard_controller.send(:inquiries_per_student)
      expect(inquiries_per_student[:count].size).to eq(2)
      expect(inquiries_per_student[:questions].size).to eq(2)
    end

  end
end
