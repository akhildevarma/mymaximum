require 'feature_helper'

include SessionHelper

feature 'Teams Admin', :js do
  let!(:teams) { create_list :team, 3, :with_5_members }
  let(:team) { build :team }
  let(:fields) { [ 'Name', 'SignUp URL Path','Admin Email', 'Email Domain' ] }
  # before(:each) { Rails.cache.clear }
  before :each do
    @current_user = login_as_admin
    set_current_user_to_teams
    set_one_not_yet_activated_user_in_team
    team.user = @current_user
    visit '/'
    click_on "Admin"
    click_on "Teams"
  end

  scenario 'can see list of teams' do
    for team in teams
      expect(page).to have_content team.name
      expect(page).to have_link( 'Members', href: members_custom_admin_team_path( team ) )
    end
  end

  scenario 'can create new team' do
    click_on 'Create Team'
    for field in fields
      fill_in field, with: team.send(field.downcase.gsub(' ','_').to_sym)
    end
    click_on 'Create Team'
    expect(page).to_not have_http_status :error
    # Test all persisted
    submission_persisted?(team)
    expect(team.user).to eq(@current_user)
  end

  scenario 'can see list of team members' do
    team_info = set_team_info
    click_members(team_info)
    expect(page).to have_content team_info.name
    can_have_support_details
    can_have_add_user_details(team_info)
    can_have_remove_from_team_link(team_info)
    can_have_resend_invitation_link(team_info)
  end

  scenario 'can resend invite to team member' do
    team_info = set_team_info
    last_user = team_info.users.last
    click_members(team_info)
    click_specific_link(last_user,'Resend Invitation')
    receive_an_email(last_user)
    expect(page).to_not have_http_status :error
  end

  scenario 'can remove from team' do
    team_info = set_team_info
    first_user = team_info.users.first
    click_members(team_info)
    click_specific_link(first_user,'Remove from Team')
    expect(page).to_not have_http_status :error
    expect(page).to_not have_link('Remove from Team',href: remove_from_team_custom_admin_team_path(first_user))
  end

  scenario 'can update team settings' do
    team = set_team_info
    within("#team_#{team.id}") { click_on 'View' }
    for field in fields
      expect(page).to have_content field
    end
    fill_in 'Name', with: team.name
    click_on 'Update Team'
    expect(page).to_not have_http_status :error
    # Test all persisted
    submission_persisted?(team)
  end

  def click_members(team_info)
    within("#team_#{team_info.id}") { click_on 'Members' }
  end

  def click_specific_link(user, link)
    within("#user_#{user.id}") { click_on link }
  end

  def set_current_user_to_teams
    teams.each { |team|
      team.user = @current_user
      team.save
    }
  end

  def set_one_not_yet_activated_user_in_team
    last_team = teams.last
    last_user = last_team.users.last
    last_user.account_activated_at = nil
    last_user.save
    last_team.save
  end

  def set_team_info
    team_info = teams.last
    team_info.name = 'New Team Name'
    team_info.save
    team_info
  end

  def can_have_support_details
    expect(page).to have_link('here',href: 'mailto:support@InpharmD.com')
    expect(page).to have_content 'This team is managed by InpharmD™. Click here to contact admin'
  end

  def can_have_add_user_details(team_info)
    expect(page).to have_link('Add User',href: '#')
    add_invalid_email
    add_valid_email(team_info)
  end

  def can_have_remove_from_team_link(team_info)
    user = team_info.users.first
    expect(page).to have_link( 'Remove from Team', href: remove_from_team_custom_admin_team_path( user, team_id: team_info.id ) )
  end

  def can_have_resend_invitation_link(team_info)
    user = team_info.users.last
    expect(page).to have_link('Resend Invitation')
  end

  def add_invalid_email
    fill_in 'email', with: 'test'
    click_on 'Add User'
    expect(page).to have_content(I18n.t('teams.invalid_email'))
  end

  def add_valid_email(team_info)
    user = FactoryGirl.build(:user,last_active_at: Time.now)
    user.save(validate: false)
    user.update_attribute(:account_activation_token, nil)
    fill_in 'email', with: user.email
    click_on 'Add User'
    receive_an_email(user)
    expect(page).to have_content(I18n.t('teams.existing_user_success',email: user.email))
    expect(User.last.account_activation_token).to_not eq(nil)
  end

  def receive_an_email(user)
    open_email(user.email)
  end

  def submission_persisted?(team)
    submitted = Team.last
    for field in fields
      attribute = field.downcase.gsub(' ','_').to_sym
      expect(submitted.send(attribute)).to eq team.send(attribute)
    end
  end
end
