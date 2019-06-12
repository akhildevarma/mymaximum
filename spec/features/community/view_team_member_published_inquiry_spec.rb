require 'feature_helper'

include SessionHelper

feature 'View team member published inquiry' do
  let(:team) { create :team }
  let!(:me) {  create :provider_user, team: team }
  let!(:somebody) { FactoryGirl.create(:provider_user) }
  let!(:my_inquiry) { FactoryGirl.create(:published_inquiry, submitter: me, view_everyone: false) }
  let!(:somebodys_inquiry) { FactoryGirl.create(:inquiry, submitter: somebody) }
  let(:guid) { create :guid, referenceable: my_inquiry }
  let(:uniq_url) { "/#{guid.uid}" }
  before :each do
    page.set_rack_session(referer_url: uniq_url)
    visit uniq_url
  end

  scenario 'Team member can navigates to login page' do
    expect(page).to have_content('Login')
  end

  scenario 'Logged in Team member can view published inquiry details' do
    fill_login_form_with(email: me.email, password: 'foobar')
    expect(page).to have_content my_inquiry.question
    expect(page).to have_content 'Background'
  end

   scenario 'Logged in Non Team member can not view published inquiry details' do
    expect { fill_login_form_with(email: somebody.email, password: 'foobar') }.to raise_error(ActiveRecord::RecordNotFound)
  end
end
