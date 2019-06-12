require 'rails_helper'

describe PreventMailInterceptor, 'delivery interception' do
  let(:active_user) { create :user, is_active: true }
  let(:inactive_user) { create :user, is_active: false }
  it 'prevents mailing for inactive recipients/users' do
    PreventMailInterceptor.stub(deliver?: false)
    expect do
      deliver_mail(inactive_user)
    end.not_to change(ActionMailer::Base.deliveries, :count)
  end

  it 'allows mailing active recipients/users' do
    PreventMailInterceptor.stub(deliver?: true)
    expect do
      deliver_mail(active_user)
    end.to change(ActionMailer::Base.deliveries, :count)
  end

  def deliver_mail(user)
    SignupMailer.welcome(user).deliver_now
  end
end

describe PreventMailInterceptor, '.deliver?' do
  let(:active_user) { create :user, is_active: true }
  let(:inactive_user) { create :user, is_active: false }
  it 'is false for inactive recipients/users' do
    message =  SignupMailer.welcome(inactive_user).deliver_now
    expect(PreventMailInterceptor.deliver?(message)).to eq false
  end

  it 'is true for active recipients/users' do
    message = SignupMailer.welcome(active_user).deliver_now
    expect(PreventMailInterceptor.deliver?(message)).to eq true
  end

  it 'is true for invitation emails - no user exist' do
    invitation = Invitation.new(email: 'abc@inpharmd.com', invitation_type: 'student')  
    message = InvitationMailer.invite_student(active_user, invitation).deliver_now
    expect(PreventMailInterceptor.deliver?(message)).to eq true
  end

  it 'is true for password emails' do
    message = UserMailer.password_reset(inactive_user).deliver_now
    expect(PreventMailInterceptor.deliver?(message)).to eq true
  end
end

describe PreventMailInterceptor, 'send it to primary email address' do
  let!(:active_user) { create :user, is_active: true }
  
  context 'when is_primary set to true in User::Email table ' do
    let!(:user_email) { User::Email.create(email: 'test@inpharmd.com', user_id: active_user.id, is_primary: true) }
    it 'recipient set it from user::email table' do
      message = SignupMailer.welcome(active_user).deliver_now
      expect(message.to).to eq [user_email.email]
    end
  end

  context 'when is_primary set to false/nil in User::Email table ' do
    let!(:user_email) { User::Email.create(email: 'test@inpharmd.com', user_id: active_user.id, is_primary: false) }
    it 'recipient set it from user table' do
      message =  SignupMailer.welcome(active_user).deliver_now
      expect(message.to).to eq [active_user.email]
    end
  end

  context 'when User::Email table empty' do
    it 'recipient set it from user table' do
      message =  SignupMailer.welcome(active_user).deliver_now
      expect(message.to).to eq [active_user.email]
    end
  end
end
