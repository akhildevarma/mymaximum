  class API::V1::Admin::ApplicationController < ::ApplicationController
    skip_before_filter :license_number_needed?
    before_filter :authenticate_admin

    layout 'admin'

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
      team_id  = (params[:team_id] || params[:uploader][:team_id])
      @team = Team.find(team_id)
    end
  end
