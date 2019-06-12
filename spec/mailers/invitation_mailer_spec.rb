require 'rails_helper'

describe InvitationMailer do
  describe '#invite' do
    let(:user) { FactoryGirl.build_stubbed(:provider_user).decorate }
    let(:invitation) { FactoryGirl.build_stubbed(:invitation, user: @user) }
    let(:mail) { InvitationMailer.invite(user, invitation) }
    before do
      invitation.send :generate_token
    end
    it 'renders the subject' do
      expect(mail.subject).to eql(I18n.t('invitation.invite_subject'))
    end

    it 'renders the receiver email' do
      expect(mail.to).to eql([invitation.email])
    end

    it 'assigns @inviter' do
      expect(mail.body.encoded).to match(user.email)
    end

    context 'invitation token not required' do
      before do
        ApplicationSettings.load.update_attribute :require_general_invitations, false
      end
      it 'does not assign @invitation_params' do
        expect(mail.body.encoded).to_not include(invitation.token)
        expect(mail.body.encoded).to include('http://test.host/signup')
      end
    end
  end

  describe '#invite_student' do
    let(:user) { FactoryGirl.build_stubbed(:student_user).decorate }
    let(:invitation) { FactoryGirl.build_stubbed(:invitation, user: user) }
    subject { InvitationMailer.invite_student(user, invitation) }
    before { invitation.send(:generate_token) }

    it 'renders the subject' do
      expect(subject.subject).to eq I18n.t('invitation.invite_student_subject')
    end

    it 'renders the receiver email' do
      expect(subject.to).to eq [invitation.email]
    end

    it 'assigns @inviter' do
      expect(subject.body.encoded).to match(user.email)
    end

    it 'has a invitation token' do
      expect(subject.body.encoded).to include(invitation.token)
    end
  end
end
