require 'rails_helper'

describe 'inquiries/edit.html.erb' do
  let(:user) {
    FactoryGirl.build_stubbed(:student_user).decorate
  }

  before { @inquiry = FactoryGirl.create(:inquiry_with_table, status: :review, submitter: user).decorate }

  before do
    @inquiry.stub(:assignee_name).and_return(user.full_name_or_email)
    @inquiry.stub(:assigned_to_me?).and_return(true)
  end

  context 'summary table with responder' do
    it 'includes respond to an inquiry text' do
      render
      expect(rendered).to include("Respond to an inquiry")
    end

    it 'includes assignee_name' do
      render
      expect(rendered).to include(@inquiry.assignee_name)
    end

    it 'includes summary table responders email' do
      render
      responder = @inquiry.summary_tables[0].responder
      expect(rendered).to include(responder.email)
    end
  end

  context 'summary table with no responder' do
     it 'does not includes summary table responders email' do
      responder = @inquiry.summary_tables[0].responder
      @inquiry.summary_tables[0].responder = nil
      render
      expect(rendered).to_not include(responder.email)
    end
  end

  context 'no summary table for inquiry' do
     it 'includes no one has submitted any tables yet' do
      @inquiry.summary_tables = []
      render
      expect(rendered).to include('No one has submitted any tables yet.')
    end
  end
end
