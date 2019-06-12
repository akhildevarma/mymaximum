require 'rails_helper'

RSpec.describe SignupMailer do
  describe 'instructions' do
    let(:user) { build_stubbed :provider_user }
    let(:mail) { SignupMailer.welcome(user) }

    it 'renders the subject' do
      expect(mail.subject).to eql('Welcome to InpharmD™!')
    end

    it 'renders the receiver email' do
      expect(mail.to).to eql([user.email])
    end

    it 'renders the sender email' do
      mail_from = mail.message[:from].value
      expect(mail_from).to eql("\"InpharmD™\" <support@inpharmd.com>")
    end

    it 'assigns @name' do
      expect(mail.body.encoded).to match(user.decorate.name)
    end
  end
end
