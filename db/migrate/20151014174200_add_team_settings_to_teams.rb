class AddTeamSettingsToTeams < ActiveRecord::Migration
  def change
    add_column :teams, :admin_email, :string
    add_column :teams, :signup_url_path, :string
    add_column :teams, :email_domain, :string
  end
end
