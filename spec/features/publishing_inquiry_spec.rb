require 'feature_helper'

include SessionHelper

feature 'Publishing Inquiry' , :allow_net_connections, :js do
  let!(:completed) { create :completed_inquiry, title: 'publish this inquiry' }
  let!(:guid) { create :guid, referenceable: completed }

  before do
    login_as_admin
    visit "/#{completed.slug}"
  end

  scenario 'admin can publish any completed and valid Inquiry' do
    click_on "Publish"
    within('#modalPublish') do
      page.should have_content('View everyone')
      page.should have_content('Publishable title')
      page.should have_content('Question')
      fill_in 'inquiry_title', with: 'changing title'
      fill_in 'inquiry_question', with: 'modifying question'
      click_on 'Submit'
    end

    completed.reload
    expect(completed.published_at).not_to eq(nil) 
  end
end
