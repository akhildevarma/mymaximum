require 'rails_helper'

describe JsonErrorResource do
  let(:including_class) { Class.include(JsonErrorResource) }
  let(:class_instance) { including_class.new }
  let(:errors) { class_instance.errors.tap { |e| e.add(:base, 'test') } }
  let(:key) { including_class.class.name.to_sym }
  let(:association_with_errors) do
    including_class.new.tap { |association| association.errors.add(:name) }
  end
  let(:expected_json_errors) { Hash.new(key: errors) }
  let(:expected_json_errors_with_associations) { Hash.new(key: errors) }

  context 'class methods' do
    subject { class_instance.class }
    before { allow(subject.class).to receive(:json_error_associations).and_return [:association] }
    its(:json_error_associations) { is_expected.to eq [:association] }
  end

  context 'instance methods' do
    subject { class_instance }
    before do
      subject.class.send :attr_accessor, :association
      allow(subject.class).to receive(:json_error_associations).and_return [:association]
      allow(subject).to receive(:association).and_return(association_with_errors)
    end
    context 'json_errors no associations' do
      its(:json_errors) { is_expected.to be_kind_of Hash }
      its(:json_errors) { is_expected.to include expected_json_errors }
    end
    context 'json_errors with nil association' do
      before { allow(subject).to receive(:association).and_return(nil) }
      its(:json_errors) { is_expected.to be_kind_of Hash }
      its(:json_errors) { is_expected.to include Hash.new(association: {}) }
    end
    context 'json_errors with associations' do
      its(:json_errors) { is_expected.to have_key(:association) }
      after do
        subject.json_errors
      end
      it { expect(subject).to receive(:json_errors).once }
      it { expect(subject).to receive(:association).once }
      it { expect(subject.class).to receive(:json_error_associations).once }
    end
  end
end
