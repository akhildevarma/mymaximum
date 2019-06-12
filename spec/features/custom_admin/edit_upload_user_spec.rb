require 'feature_helper'
include SessionHelper

feature 'Edit upload users' do
  let(:team) { create :team }
  let(:upload_user) { create :upload_user,team_id: team.id, status: UploadUser::ERROR}
  let(:fields) { [ 'Email','Specialty' ] }
  let(:email) { Faker::Internet.email }
  before :each do
    @current_user = login_as_admin
    @email = upload_user.email
    visit_uploaded_users_path
  end

  scenario 'can see list of failed uploaded users' do
    expect(page).to have_content(upload_user.email)
    expect(page).to have_content(upload_user.specialty)
    expect(page).to have_content('Edit')
  end

  scenario 'can update failed uploaded users' do
    within("#upload_user_#{team.id}") { click_on 'Edit' }
    verify_content
    fill_details
    click_on 'Update Upload user'
    expect(page).to have_http_status 200
    user_profile_provider_persisted?
  end

  def verify_content
    for field in fields
      expect(page).to have_content field
    end
  end

  def user_profile_provider_persisted?
    Timecop.travel(Time.now + 1.hours)
    expect(User.last.email).to eq(email)
    expect(Provider.last.specialty).to eq('SOME SPL')
  end

  def fill_details
    fill_in 'Email', with: email
    fill_in 'Specialty', with:  'SOME SPL'
  end

  def visit_uploaded_users_path
    set_current_user_to_team
    visit '/'
    within('#nav-sm') { click_on "Teams" }
    within("#team_#{team.id}") { click_on 'Members' }
    click_on "Uploaded Users"
  end

  def set_current_user_to_team
    team.user = @current_user
    team.save
    upload_user.save
  end
end
