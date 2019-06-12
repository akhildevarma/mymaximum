require 'feature_helper'

include SessionHelper

feature 'Viewing closed inquiries as a student' do
  let!(:inquiry) { FactoryGirl.create(:completed_inquiry) }

  scenario 'Student sees all open inquiries' do
    login_as_student
    visit '/inquiries/closed'

    expect(page).to have_content('Closed Inquiries')
    within('#inquiries') do
      expect(page).to have_content("Submitted by #{inquiry.submitter.full_name_or_email}")
      expect(page).to have_content('Due on')
      expect(page).to have_content('Completed on')
    end
  end
end
