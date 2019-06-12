require 'rails_helper'

describe StudentSignup do
  context 'with a valid invitation / email combination' do
    let(:invitation) { FactoryGirl.create(:student_invitation) }

    let(:signup) do
      signup = StudentSignup.new(invitation: invitation)
      signup.email = invitation.email
      signup.user.password = 'foobar'
      signup.user.password_confirmation = 'foobar'
      signup
    end

    before :each do
      allow(Invitation).to receive(:where) { [invitation] }
      allow_any_instance_of(Invitation).to receive(:queue_signup_reminder) { true }
    end

    it 'saves successfully' do
      expect(signup.save).to be true
    end

    it 'creates a user with the provided email address' do
      signup.save
      expect(signup.user).to be_persisted
      expect(signup.user.email).to eq(invitation.email)
    end

    it 'creates a user who is a student' do
      signup.save
      expect(signup.user).to be_student
    end
  end

  context 'without an invitation' do
    let(:signup) do
      signup = StudentSignup.new
      signup.email = 'sneaky@haxor.biz'
      signup.user.password = 'foobar'
      signup.user.password_confirmation = 'foobar'
      signup
    end

    it 'does not save successfully' do
      expect(signup.save).to be false
    end

    it 'does not persist anything' do
      signup.save
      expect(signup.user).to_not be_persisted
      expect(signup.student).to_not be_persisted
    end
  end
end
