require 'feature_helper'
include SessionHelper

feature 'Emails' do
  let!(:user_record) { create :user }
  let!(:user_emails) { create_list :user_email, 2, user: user_record }

  scenario 'each can be used to login successfully' do
    user_emails.each do |email_record|
      email_record.activate_email!
      test_login with_user email: email_record.email
    end
  end

  scenario 'if none then fallback to existing user email' do
    test_login with_user from: user_record
  end

  scenario 'if login with deprecated email then show warning message' do
    deprecated = create :user_email, is_deprecated: true, user: user_record
    deprecated.activate_email!
    test_login with_user email: deprecated.email
    expect(page).to have_content deprecation_warning
  end

  def test_login(user)
    login user
    expect(page).to_not have_content session_error
  end

  def session_error
    I18n.t("sessions.error")
  end

  def deprecation_warning
    "Your team no longer supports this email. In future please login with #{user_record.email}"
  end

  def with_user(options)
    if options[:email]
      OpenStruct.new( email: options.fetch(:email), password: user_record.password )
    else
      options[:from]
    end
  end

end
