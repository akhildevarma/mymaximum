require 'feature_helper'

feature 'Team provider signup', :vcr do
  scenario 'via special team link' do
    team_provider_path = new_provider_signup_path +
                         '?' + { 'user[team_id]': '1' }.to_query

    visit team_provider_path
    expect(page).to_not have_content('Coupon code')
    expect(page).to_not have_content('Promo code')
  end
end
