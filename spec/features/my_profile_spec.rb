require 'feature_helper'

include SessionHelper

feature 'Make changes to my profile' do
  context 'As a provider' do
    before do
      login_as_provider
      visit '/my_profile/edit'
    end
    scenario 'I can see deactivate account related section' do
      expect(page).to have_content(I18n.t('account.deactivate.title'))
      expect(page).to have_content(I18n.t('account.deactivate.message'))
      expect(page).to have_content(I18n.t('account.deactivate.button'))
    end

    scenario 'I can deactivate/reactivate my account' do
      click_on I18n.t('account.deactivate.button')
      expect(User.first.is_active).to be false
      expect(page).to have_content('Login')
      fill_login_form_with(email: User.first.email, password: 'foobar')
      expect(User.first.is_active).to be true
    end
  end
end
