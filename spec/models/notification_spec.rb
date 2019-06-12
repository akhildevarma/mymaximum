require 'rails_helper'

describe Notification do
  describe '#notify' do
    let(:instance) { build :notification }
    subject { instance }

    it 'sends notification after create' do
      instance.should_receive(:send_sms_notification)
      instance.save
    end
  end

  describe '.send_inquiry_inactive_notification' do
    before { create_list :inquiry_with_assignee, 1, turnaround_time: 'a_week' }
    context 'inactive for last 3 hours' do
      before do
        Timecop.travel(Time.now + 3.hours)
        Notification.send_inquiry_inactive_notification(Notification::INACTIVE_LAST_3HOURS,Notification::SMS)
      end

      it 'does create notification record' do
        expect(Notification.last).not_to be_nil
        expect(Notification.count).to eq 1
        expect(Notification.last.message).to eq (I18n.t("notifications.#{Notification::INACTIVE_LAST_3HOURS}"))
      end

      it 'does not create notification record' do
        Notification.send_inquiry_inactive_notification(Notification::INACTIVE_LAST_3HOURS,Notification::SMS)
        expect(Notification.last).not_to be_nil
        expect(Notification.count).to eq 1
      end
      after { Timecop.return }
    end

    context 'does not inactive for last 3 hours' do
      before do
        Timecop.travel(Time.now + 2.hours)
        Notification.send_inquiry_inactive_notification(Notification::INACTIVE_LAST_3HOURS,Notification::SMS)
      end

      it 'does not create notification record ' do
        expect(Notification.last).to be_nil
        expect(Notification.count).to eq 0
      end
      after { Timecop.return }
    end
  end

end
