require 'feature_helper'

include SessionHelper

feature 'Submitting an inquiry', :vcr do

  let!(:me) { login_as_provider }

  scenario 'Provider can submit an inquiry' do
    visit root_path

    fill_in 'New Inquiry', with: 'A serious question'
    # select 'As soon as possible', from: 'Turnaround time'
    find('input[name="commit"]').click

    expect(page).to have_content('Inquiry submitted successfully')
  end

  context 'with a completed inquiry' do
    let!(:inquiry) { FactoryGirl.create(:inquiry_with_table, submitter: me, status: :complete) }
    scenario "Provider can view the inquiry's response" do
      visit my_inquiries_path
      find("#completed_inquiry_#{inquiry.id}").click
      expect(page).to have_content(inquiry.question)
    end
  end
end
