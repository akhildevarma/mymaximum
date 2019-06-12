require 'feature_helper'

include SessionHelper

feature 'News' do
  let!(:published) { create_list :published_inquiry, 2, view_everyone: true }
  let!(:guid) { create :guid, referenceable: published.first }

  before do
    login_as_provider
    visit '/news'
  end

  scenario 'provider can view published inquiries' do
    expect(page).to have_content('Recently Published Inquiries')
    published.each do |inquiry|
      expect(page).to have_content(inquiry.title)
    end
  end
end
