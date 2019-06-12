require 'rails_helper'

describe InquiryDecorator do
  let(:inquiry) { FactoryGirl.build_stubbed(:inquiry).decorate }

  describe '#progress_bar_unit_width' do
    subject { inquiry.progress_bar_unit_width }
    it { is_expected.to eq (100.0/Inquiry.statuses.size) }
  end

  describe '#progress' do
    subject { inquiry }
    Inquiry.statuses.each do |status|
      it do
        subject.status = status
        expect(subject.progress).to eq(subject.progress_bar_unit_width * subject.passed_statuses.length)
      end
    end
  end


end
