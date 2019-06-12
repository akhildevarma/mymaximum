require 'feature_helper'

include SessionHelper

feature 'Show specific user' do
  before do
  end
  context 'student user' do
    let!(:user) { FactoryGirl.create(:student_user) }

    scenario 'show student user' do
      login_as_admin
      visit custom_admin_user_path(user)

      expect(page).to_not have_content('error')
    end
  end
end
