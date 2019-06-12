require 'rails_helper'

class TestMailer < ApplicationMailer
  def test
    mail(to: 'test@mail.com', body: 'test body')
  end
end

describe ApplicationMailer do
  let(:test_mail){ TestMailer.test }
  let(:sender) { test_mail.message[:from].value }

  subject { sender }
  it { is_expected.to eql("\"InpharmD™\" <support@inpharmd.com>") }
end
