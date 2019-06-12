require 'rails_helper'

describe ProviderSignupErrorSerializer do
  let(:erroneous_provider_signup) do
    ProviderSignup.new(
      user: {
        email: 'coolguy@provider.biz',
        password: 'foobar',
        password_confirmation: 'not matching'
      },
      profile: { first_name: 'Guy' },
      provider: {
        license_number: '098382942'
      },
      payment_account: {
        plan_id: 'a_la_carte',
        last_four_digits: '1234'
      },
      accept_terms_of_service: 0
    ).tap { |ps| ps.save }
  end
  let(:json_error_response) do
    {
      provider_signup: {
        accept_terms_of_service: ['must_be_accepted']
      },
      user: {
        password_confirmation: ['must_match_password']
      },
      provider: {
        licensing_state: ['cant_be_blank']
      },
      profile: {
         last_name: ['cant_be_blank']
      },
      payment_account: {}
    }.to_json
  end
  subject(:serializer) { ProviderSignupErrorSerializer.new(erroneous_provider_signup) }

  # Instance Methods
  describe '#initialize' do
    it { is_expected.to be_a ProviderSignupErrorSerializer }
    it { is_expected.to be_kind_of ErrorSerializer }
    describe '@object' do
      subject(:object) { serializer.instance_variable_get(:@object) }
      it { is_expected.to eq erroneous_provider_signup }
    end
  end

  describe '#generate_json_messages_for' do
    let(:error) { erroneous_provider_signup.json_errors[:provider_signup] }
    let(:expected_text) { 'must_be_accepted' }
    subject { serializer.send :generate_json_messages_for, error }
    it { is_expected.to eq accept_terms_of_service: [expected_text] }
  end

  describe '#attributes' do
    subject { serializer.send :attributes }
    it { is_expected.to be_kind_of Hash }
  end

  # Class Methods
  describe '.excluded_attributes' do
    subject { serializer.class.excluded_attributes }
    it { is_expected.to eq [:user_id] }
  end

  # Public Methods
  describe '#to_json' do
    subject { serializer.to_json }
    it { is_expected.to eq json_error_response }
  end
end
