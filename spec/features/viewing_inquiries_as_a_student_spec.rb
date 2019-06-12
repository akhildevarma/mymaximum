require 'feature_helper'

include SessionHelper

feature 'Viewing inquiries as a student' do
  before(:each) do
    FactoryGirl.create(:inquiry)
  end

  scenario 'Student sees all open inquiries' do
    login_as_student
    visit '/inquiries'

    expect(page).to have_content('Open Inquiries')
    within('#inquiries') do
      expect(page).to have_content('This test question is about something very important!')
    end
  end
end
