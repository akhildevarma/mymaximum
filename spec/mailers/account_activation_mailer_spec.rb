require "rails_helper"

RSpec.describe AccountActivationMailer, type: :mailer do 
  describe 'add_team_activation' do
    let(:team) { create :team}
    let(:user) { create :empty_provider_user, team_id: team.id }
    let(:mail) { AccountActivationMailer.add_team_activation(user) }

    it 'renders the subject' do
      expect(mail.subject).to eql(I18n.t('account.activation.add_team_subject'))
    end

    it 'renders the receiver email' do
      expect(mail.to).to eql([user.email])
    end

    it 'renders the sender email' do
      mail_from = mail.message[:from].value
      expect(mail_from).to eql("\"InpharmD™\" <support@inpharmd.com>")
    end

    it 'assigns @team_name' do
      expect(mail.body.encoded).to match(team.name)
    end
  end
end
