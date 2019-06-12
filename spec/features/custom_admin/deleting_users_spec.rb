require 'feature_helper'

include SessionHelper

feature 'Deleting Users' do
  before do
    allow(StripeCustomerRemover).to receive_messages(run: true)
  end

  let!(:user) { FactoryGirl.create(:patient_user) }

  scenario 'deleting a user' do
    login_as_admin
    visit custom_admin_users_path
    within("#user_#{user.id}") do
      find('[rel~="delete-user"]').click
    end

    expect(page).to_not have_content(user.profile.phone_number)
  end
end
