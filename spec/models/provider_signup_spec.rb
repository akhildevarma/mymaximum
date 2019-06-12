require 'rails_helper'

describe ProviderSignup, :vcr do
  before :each do
    allow(Invitation).to receive(:where) { [invitation] }
    allow_any_instance_of(Invitation).to receive(:queue_signup_reminder) { true }
    allow_any_instance_of(PaymentAccount).to receive(:update_stripe_subscription) { true }
    allow_any_instance_of(PaymentAccount).to receive(:update_card_information) { true }
    allow(Stripe::Customer).to receive(:create) { double(id: '12345') }
  end

  let(:invitation) { FactoryGirl.create(:invitation) }
  let(:signup_with_invitation) do
    signup = ProviderSignup.new(invitation: invitation)
    signup.email = invitation.email
    signup.user.password = 'foobar'
    signup.user.password_confirmation = 'foobar'
    signup.provider.license_number = '12345'
    signup.provider.licensing_state = 'Georgia'
    signup.provider.specialty = 'Pharmacist'
    signup.profile = FactoryGirl.attributes_for(:profile)
    signup.payment_account = FactoryGirl.attributes_for(:provider_payment_account)
    signup
  end

  let(:signup_without_invitation) do
    signup = ProviderSignup.new
    signup.email = 'some_random_weirdo@website.biz'
    signup.user.password = 'foobar'
    signup.user.password_confirmation = 'foobar'
    signup.provider.license_number = '12345'
    signup.provider.licensing_state = 'Georgia'
    signup.provider.specialty = 'Pharmacist'
    signup.profile = FactoryGirl.attributes_for(:profile)
    signup.payment_account = FactoryGirl.attributes_for(:provider_payment_account)
    signup
  end

  context 'errrors in signup' do
    let(:signup) { build :provider_signup_with_errors }
    it 'fails to save' do
      expect(signup.save).to be false
    end
    it 'returns json errors' do
      expect(signup.json_errors).to be_kind_of Hash
      expect(signup.json_errors[:provider_signup]).to be_kind_of ActiveModel::Errors
    end
  end

  context 'when general invitations are required' do
    before do
      ApplicationSettings.load.update!(require_general_invitations: true)
    end

    context 'with a valid invitation / email combination' do
      let(:signup) { signup_with_invitation }
      it 'saves successfully' do
        expect(signup.save).to be true
      end

      it 'creates a user with the provided email address' do
        signup.save
        expect(signup.user).to be_persisted
        expect(signup.user.email).to eq(invitation.email)
      end

      it 'creates a user who is a provider' do
        signup.save
        expect(signup.user).to be_provider
        expect(signup.provider).to be_persisted
      end

      it 'creates a profile for the user' do
        signup.save
        expect(signup.profile).to be_persisted
        expect(signup.profile.user_id).to eq(signup.user.id)
      end

      it 'creates a payment account for the user' do
        signup.save
        expect(signup.payment_account).to be_persisted
        expect(signup.payment_account.user_id).to eq(signup.user.id)
      end

      it 'only accepts general invitation tokens' do
        invitation.invitation_type = Invitation::STUDENT_INVITATION_TYPE
        signup.save
        expect(signup.invitation.errors.keys).to include(:token)
      end
    end

    context 'without an invitation' do
      let(:signup) { signup_without_invitation }

      it 'does not save successfully' do
        expect(signup.save).to be false
      end
    end
  end

  context 'when general invitations are not required' do
    before do
      ApplicationSettings.load.update!(require_general_invitations: false)
    end
    context 'without an invitation' do
      let(:signup) { signup_without_invitation }
      it 'saves successfully' do
        expect(signup.save).to be true
      end

      it 'creates a user with the provided email address' do
        signup.save
        expect(signup.user).to be_persisted
      end

      it 'creates a user who is a provider' do
        signup.save
        expect(signup.user).to be_provider
        expect(signup.provider).to be_persisted
      end

      it 'creates a profile for the user' do
        signup.save
        expect(signup.profile).to be_persisted
        expect(signup.profile.user_id).to eq(signup.user.id)
      end

      it 'creates a payment account for the user' do
        signup.save
        expect(signup.payment_account).to be_persisted
        expect(signup.payment_account.user_id).to eq(signup.user.id)
      end
    end
  end
end
