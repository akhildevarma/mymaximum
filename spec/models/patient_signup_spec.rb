require 'rails_helper'

describe PatientSignup do
  let(:invitation) { FactoryGirl.create(:invitation) }
  it { is_expected.to be_kind_of JsonErrorResource }

  let(:signup_with_invitation) do
    signup = PatientSignup.new(invitation: invitation)
    signup.email = invitation.email
    signup.user.password = 'foobar'
    signup.user.password_confirmation = 'foobar'
    signup.profile = FactoryGirl.attributes_for(:profile)
    signup
  end

  let(:signup_without_invitation) do
    signup = PatientSignup.new
    signup.email = 'mysterious_patient@aol.com'
    signup.user.password = 'foobar'
    signup.user.password_confirmation = 'foobar'
    signup.profile = FactoryGirl.attributes_for(:profile)
    signup
  end

  before :each do
    allow(Invitation).to receive(:where) { [invitation] }
    allow_any_instance_of(Invitation).to receive(:queue_signup_reminder) { true }
    allow_any_instance_of(PaymentAccount).to receive(:update_stripe_subscription) { true }
    allow_any_instance_of(PaymentAccount).to receive(:update_card_information) { true }
    allow(Stripe::Customer).to receive(:create) { double(id: '12345') }
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

      it 'creates a user who is a patient' do
        signup.save
        expect(signup.user).to be_patient
        expect(signup.patient).to be_persisted
      end

      it 'creates a profile for the user' do
        signup.save
        expect(signup.profile).to be_persisted
        expect(signup.profile.user_id).to eq(signup.user.id)
      end

      it 'creates a payment account for the user' do
        signup.save
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

      it 'does not persist anything' do
        signup.save
        expect(signup.user).to_not be_persisted
        expect(signup.patient).to_not be_persisted
        expect(signup.profile).to_not be_persisted
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

      it 'creates a user who is a patient' do
        signup.save
        expect(signup.user).to be_patient
        expect(signup.patient).to be_persisted
      end

      it 'creates a profile for the user' do
        signup.save
        expect(signup.profile).to be_persisted
        expect(signup.profile.user_id).to eq(signup.user.id)
      end

      it 'creates a payment account for the user' do
        signup.save
      end
    end
  end
end
