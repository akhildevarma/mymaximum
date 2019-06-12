require 'rails_helper'

describe ApplicationController do
  describe '#current_user' do
    let(:current_user) { controller.send :current_user }
    subject { current_user }
    context 'user present' do
      before { allow(User).to receive(:find_by_id).and_return(create :user) }
      it { is_expected.to be_decorated }
      its(:last_active_at){ is_expected.to_not be_nil }
    end
    context 'user nil' do
      before { allow(User).to receive(:find_by_id).and_return(nil) }
      it { is_expected.to be_nil }
    end
  end

  describe '#errors_for' do
    context 'model_instance not JsonErrorResource' do
      it 'rasies error' do
        controller = ApplicationController.new
        expect do
          controller.send :errors_for, double(Class)
        end.to raise_error 'Must inherit JsonErrorResource'
      end
    end

    context 'model_instance inherits JsonErrorResource' do
      it 'does not rasie an error' do
        controller = ApplicationController.new
        expect do
          controller.send :errors_for, Class.include(JsonErrorResource).new
        end.to_not raise_error
      end
    end
  end
end
