class CustomAdmin::DownloadsController < CustomAdmin::ApplicationController

  USER_RESOURCE_OPTIONS = {
    full_attributes: {
      attributes: ['id', 'email', 'password_digest', 'created_at', 'team_id'],
      profile_attributes: %w(first_name middle_name last_name name_suffix name_title company city state phone_number)
    },
    limited_attributes: {
      attributes: ['email', 'created_at', 'last_active_at'],
      profile_attributes: ['first_name', 'last_name'],
      team_attributes: ['name']
    }
  }

  before_filter :set_resource

  def show
    send_csv
  end


  private
  def send_csv
    send_data @resource.to_csv( options_for_resource )
  end

  def set_resource
    @id = params[:id]
    @resource = case @id
    when /users/
      users_resource[@id]
    when 'inquiries'
      Inquiry.order(created_at: :desc)
    end
  end

  def options_for_resource
    case @id
    when /users$/
      USER_RESOURCE_OPTIONS[:full_attributes]
    when /users-/
      USER_RESOURCE_OPTIONS[:limited_attributes]
    else
      nil
    end
  end

  def users_resource
    @users = User.order(created_at: :desc)
    return {
      "users": @users,
      "users-active": @users.active,
      "users-team-inactive": @users.inactive.in_team,
      "users-nonteam-inactive": @users.inactive.not_in_team,
      "users-nonteam-active": @users.active.not_in_team,
      "users-team-invited": @users.invited.in_team
    }.with_indifferent_access
  end

end
