require 'rails_helper'

describe 'invitation_mailer/invite.html.erb' do
  before do
    @user = FactoryGirl.build_stubbed(:provider_user).decorate
    @invitation = FactoryGirl.build_stubbed(:invitation, user: @user)
    @invitation.send :generate_token
    @inviter = @invitation.user
  end
  it 'includes friendly and helpful text' do
    render
    expect(rendered).to include("You've been invited by #{@user.email} to create an account on InpharmD™.")
    expect(rendered).to include('Click here to complete signup')
  end
  context 'invitations are not required' do
    before do
      @invitation_params = nil
      render
    end
    it 'does not display invitation code' do
      expect(rendered).to_not include(@invitation.token)
    end
  end
end
describe 'invitation_mailer/invite.text.erb' do
  before do
    @user = FactoryGirl.build_stubbed(:provider_user).decorate
    @invitation = FactoryGirl.build_stubbed(:invitation, user: @user)
    @invitation.send :generate_token
    @inviter = @invitation.user
  end
  it 'includes friendly and helpful text' do
    render
    expect(rendered).to include("You've been invited by #{@user.email} to create an account on InpharmD™.")
    expect(rendered).to include('Please complete signup now; copy and paste the following URL into your browser:')
  end
  context 'invitations are not required' do
    before do
      @invitation_params = nil
      render
    end
    it 'does not display invitation code' do
      expect(rendered).to_not include(@invitation.token)
    end
  end
end
