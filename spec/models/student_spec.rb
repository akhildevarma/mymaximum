require 'rails_helper'

describe Student do

  # Instance Methods
  let(:instance) { create :student }
  let(:inquiry) { create :inquiry, assignee: instance.user }

  before { Student.any_instance.stub(:send_sms_notification) }
  before { instance.assigned_inquiry = inquiry }

  subject { instance }

  describe '#assign!' do
    subject { instance.assign!(inquiry) }
    it { instance.should_receive(:notify_assigned); subject }
  end

  describe '#notify_assigned' do
    subject { instance.notify_assigned }
    it { instance.should_receive(:send_sms_notification); subject }
  end

end
