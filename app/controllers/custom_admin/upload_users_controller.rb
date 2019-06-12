class CustomAdmin::UploadUsersController < CustomAdmin::ApplicationController
  before_filter :find_team, except: [:edit,:update]
  before_filter :authenticate_admin_or_team_admin
  skip_before_filter :authenticate_admin
  
  def import
    total_rows = UploadUser.process_file(parsed_file,params[:uploader][:team_id])
    flash[:notice] = I18n.t('upload_users.success')
    redirect_to members_custom_admin_team_path(@team)
  end

  def index
    if @team
      @bulk_users = UploadUser.failed_users(@team.id).paginate(page: params[:page], per_page: 10).order(created_at: :desc)
    end
  end

  def processing
    if @team
      @count = UploadUser.to_be_processed(@team.id).count
    end
    render json: {count: @count} and return
  end

  def edit
    @upload_user  = UploadUser.find(params[:id])
  end

  def update
    @upload_user = UploadUser.find(params[:id])
    if @upload_user.update(upload_user_params[:upload_user])
      Delayed::Job.enqueue UploadJob.new(@upload_user.team_id)
      redirect_to members_custom_admin_team_path(id: @upload_user.team_id ), notice: I18n.t('upload_users.success')
    else
      render 'edit'
    end
  end


  private

    def upload_user_params
      params.permit(upload_user: [:email,:first_name,:last_name,:specialty,:phone_number,:team_id, :status,:name_suffix])
    end
    def parsed_file
      SpreadsheetParser.open_spreadsheet(params[:uploader][:file])
    end
    def find_team
      team_id  = (params[:team_id] || params[:uploader][:team_id])
      @team = Team.find(team_id)
    end
end
