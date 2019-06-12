require 'rails_helper'

RSpec.describe NotificationMailer do

  describe '#response_overdue' do
    let(:inquiry) { create :inquiry, :with_assignee }
    let(:user) { inquiry.assignee }
    let(:mail) { NotificationMailer.response_overdue(inquiry) }
    subject { mail }

    its(:subject) { is_expected.to eq I18n.t('mailer.notification.response_overdue.subject') }

    it 'renders the receiver email' do
      expect(mail.to).to eql([user.email])
    end

    it 'renders the reply_to email' do
      reply_to = mail.message[:reply_to].value
      expect(reply_to).to eql('advani_aa@mercer.edu')
    end

    it 'renders the sender email' do
      mail_from = mail.message[:from].value
      expect(mail_from).to eql("\"InpharmD™\" <support@inpharmd.com>")
    end
  end

end
