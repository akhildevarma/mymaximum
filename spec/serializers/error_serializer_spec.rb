require 'rails_helper'

describe ErrorSerializer do
  let(:model_instance) { Class.include(JsonErrorResource).new }
  let(:serializer_class) { ErrorSerializer }
  let(:serializer_instance) { ErrorSerializer.new model_instance }
  let(:errors) do
    Class.include(ActiveModel::Model).new.tap { |c| c.errors.add(:name) }.errors
  end

  ## OUTPUT
  describe '#to_json' do
    subject { serializer_instance.to_json }
    it do
      expect_any_instance_of(serializer_class).to receive(:attributes)
      subject
    end
    it { expect(JSON.parse(subject)).to be_kind_of Hash }
  end

  # Class Methods
  describe '.exluded_attributes' do
    subject { serializer_instance.class.excluded_attributes }
    it { expect { subject }.not_to raise_error }
  end

  # Instance Methods
  describe '#initialize' do
    subject { serializer_instance }
    it { expect { subject }.not_to raise_error }
  end

  describe '@object' do
    subject { serializer_instance.instance_variable_get(:@object) }
    it { is_expected.to be_kind_of ActiveModel::Model }
  end

  describe '#attributes' do
    subject { serializer_instance.send :attributes }
    context 'errors blank' do
      it { is_expected.to be_kind_of Hash }
      it { is_expected.to eq class: {} }
      it do
        expect_any_instance_of(serializer_class).to_not receive(:generate_json_messages_for)
        subject
      end
    end
    context 'errors not blank' do
      let(:model_instance) { Class.include(JsonErrorResource).new.tap { |m| m.errors.add(:name) }  }
      it do
        expect_any_instance_of(serializer_class).to receive(:generate_json_messages_for)
        subject
      end
      it { is_expected.to be_kind_of Hash }
    end
  end

  describe '#generate_json_messages_for' do
    subject { serializer_instance.send :generate_json_messages_for, errors }
    it { is_expected.to be_kind_of Hash }
  end
end
