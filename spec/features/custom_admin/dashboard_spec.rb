require 'feature_helper'

include SessionHelper

feature 'Dashboard' do
  scenario 'Admin visits dashboard' do
    login_as_admin
    visit '/custom_admin/dashboard'
    expect(page).to have_content /Inquiries(.+)Total/
    expect(page).to have_content /Inquiries(.+)Per user in 30 days/
    expect(page).to have_content /Inquiries(.+)Per team in 30 days/
    expect(page).to have_content /Topic Search(.+)Total/
    expect(page).to have_content /Topic Search(.+)Most Recent/
    expect(page).to have_content /Users(.+)Total/
    expect(page).to have_content /Users(.+)Active in 30 days/

  end
end
