require 'feature_helper'
include SessionHelper

feature 'Activate account' do

  context 'feature deactivated //' do
    before { ApplicationController.any_instance.stub(:feature?) { false } }
    context 'new user not activated' do
      given(:new_user) { create :inactive_user }
      background do
        login new_user
      end
      scenario 'does not need to activate account' do
        attempt_to_use_app
        can_now_use_app
      end
    end
  end

  context 'feature activated //' do
    before { ApplicationController.any_instance.stub(:feature?) { true } }
    context 'inactive user' do
      given(:new_user) { create :inactive_user }
      background do
        login new_user
      end
      scenario 'I must activate my account' do
        attempt_to_use_app
        redirected_to_account_activation
        receive_an_email
        click_link_in_email
        account_is_activated
        can_now_use_app
      end

      scenario 'invalid token' do
        visit "/activate_account/#{new_user.account_activation_token[0...-2]}"
        see_error_message
      end

      scenario 'resend activation email' do
        attempt_to_use_app
        redirected_to_account_activation
        resend_activation_email
        receive_an_email
        click_link_in_email
        account_is_activated
        can_now_use_app
      end
    end

    context 'user existing before feature' do
      background { login_as_provider }
      scenario 'no token' do
        destination_path = "/my_inquiries"
        visit destination_path
        expect(current_path).to eq destination_path
      end
    end
  end

  let(:attempt_to_use_app) { visit '/' }
  def redirected_to_account_activation
    account_activation_page_elements.each { |text| expect(page).to have_content text }
  end

  def receive_an_email
    open_email(new_user.email)
  end

  def click_link_in_email
    current_email.click_link 'Please click here to activate your account.'
  end

  def account_is_activated
    [
      I18n.t("account.activation.success")
    ].each { |text| expect(page).to have_content text }
  end

  def account_activation_page_elements
    [
      I18n.t("account.created"),
      I18n.t("account.activation.required"),
      I18n.t("account.activation.resend"),
      I18n.t("account.activation.resend_link")
    ]
  end

  def can_now_use_app
    account_activation_page_elements.each { |text| expect(page).to_not have_content text }
  end

  def see_error_message
    ( account_activation_page_elements << I18n.t("account.activation.errors.invalid_token")\
    ).each { |text| expect(page).to have_content text }
  end

  def resend_activation_email
    clear_emails
    click_on I18n.t("account.activation.resend_link")
    expect(page).to have_content "Account activation email sent to #{new_user.email}"
  end

end
