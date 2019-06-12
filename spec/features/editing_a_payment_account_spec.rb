require 'feature_helper'

include SessionHelper

feature 'Editing a payment account', :vcr do
  scenario 'Healthcare Provider changes current credit card' do
    login_as_provider
    visit '/payment_account/edit'
    fill_in 'Credit Card Number', with: '5555 5555 5555 4444'
    fill_in 'CVC', with: '123'
    select '12 - December', from: 'card_month'
    select '2020', from: 'card_year'
    fill_in 'Cardholder Name', with: 'Some Other Guy'
    fill_in 'Billing Zip Code', with: '77665'
    click_on 'Update Billing Information'
    expect(page).to have_content('Successfully updated billing information')
  end
end
