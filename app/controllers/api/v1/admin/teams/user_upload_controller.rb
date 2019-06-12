class API::V1::Admin::Teams::UserUploadController < API::V1::Admin::ApplicationController
  respond_to :json
  before_filter :find_team, except: [:edit,:update]
  skip_before_filter :authenticate_admin
  before_filter :authenticate_admin_or_team_admin

  def processing
    if @team
      @count = UploadUser.to_be_processed(@team.id).count
    end
    render json: {count: @count} and return
  end
end
