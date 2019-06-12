module CustomAdmin
  class ApplicationController < ::ApplicationController
    skip_before_filter :license_number_needed?
    before_filter :authenticate_admin

    def set_layout
      @layout = 'admin'
    end

    def authenticate_admin
      unless administrator?
        render file: File.join(Rails.root, 'public/403.html'), status: 403, layout: false
      end
    end

    def authenticate_admin_or_team_admin
      if (!team_admin? && @team != current_user.team) && !administrator?
        render file: File.join(Rails.root, 'public/403.html'), status: 403, layout: false
      end
    end

    def find_team
      @team = (Team.find_by_id(params[:id]) || Team.find_by_id(params[:team_id]))
      session[:team_name] = @team.signup_url_path if current_user.private_labeled_user?
    end
  end

end
