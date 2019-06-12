require 'feature_helper'

include SessionHelper

feature 'Viewing inquiries as a provider' do
  let(:team) { create :team }
  let!(:me) {  create :provider_user, team: team }
  let!(:somebody) { FactoryGirl.create(:provider_user, team: team) }
  let!(:my_inquiry) { FactoryGirl.create(:published_inquiry, submitter: me) }
  let!(:somebodys_inquiry) { FactoryGirl.create(:inquiry, submitter: somebody) }
  let(:guid) { create :guid, referenceable: my_inquiry }
  before :each do
    login me
    visit '/my_inquiries'
  end

  scenario 'Provider can view own inquiries' do
    expect(page).to have_content("Greetings from #{me.email}. This test question is about something very important!")
  end
 
  scenario "Provider cannot view someone else's inquiries" do
    expect(page).to_not have_content("Greetings from #{somebody.email}. This test question is about something very important!")
  end
end
