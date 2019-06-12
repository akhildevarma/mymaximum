class CustomAdmin::TeamsController < CustomAdmin::ApplicationController
  respond_to :html
  before_filter :find_team, except: [:index, :new, :create]
  before_filter :authenticate_admin, only: [:index, :new, :create, :show, :update ]
  before_filter :authenticate_admin_or_team_admin, only: [:remove_from_team, :add_user, :members, :resend_invite, :change_team_admin,:make_team_admin]

  class TeamParams
    def self.build params
      params.require(:team).permit(:active, :name, :cmo_name, :cmo_email, :cmo_phone, :signup_url_path, :admin_email, :email_domain, :private_label, :logo, :crop_x, :crop_y, :crop_width, :crop_height, :launch_date)
    end
  end

  def team_params
    TeamParams.build(params)
  end

  def index
    @teams = Team.where({user_id: current_user.id})
  end

  def new
    @team = Team.new
  end

  def members
    @users = UserDecorator.decorate_collection(Team.search_users(params[:search], @team).paginate(page: params[:page], per_page: 10).order(created_at: :desc))
    @total_users = @team.users.count
    @total_inquiries = Inquiry.per_team(@team).count
  end

  def team_inquiries
    @inquiries = Inquiry.per_team(@team).paginate(page: params[:page], per_page: 10).order(created_at: :desc)
  end

  def create
    @team = Team.new(team_params)
    @team.user = current_user
    if @team.save
      respond_with @team, location: custom_admin_teams_path
    else
      respond_with @team, status: :unprocessable_entity
    end
  end

  def show
  end

  def update
    @team.update(team_params)
    respond_with @team, location: custom_admin_team_path(@team)
  end

  def resend_invite
    if user = User.find(params[:id])
      @team = user.team
      user.last_active_at = Time.now
      user.save
      send_notification(user)
      flash[:notice] = "Account activation email sent to #{user.email}"
      redirect_to members_custom_admin_team_path(@team)
    end
  end

  def change_team_admin
    if user = User.find(params[:id])
      user.administrator.update_attribute(:role, :user)
      @team = user.team
      flash[:notice] = "This user's (#{user.email}) admin access has been changed!"
      redirect_to members_custom_admin_team_path(@team)
    end
  end

  def make_team_admin
    if user = User.find(params[:id])
      user.administrator.present? ? user.administrator.update_attribute(:role, :team_admin) : Administrator.create(user: user, role: :team_admin)
      @team = user.team
      flash[:notice] = "This user's (#{user.email}) admin access has been changed!"
      redirect_to members_custom_admin_team_path(@team)
    end
  end

  def remove_from_team
    if user = User.find(params[:id])
      @team = user.team
      user.team_id = nil
      user.save
      redirect_to members_custom_admin_team_path(@team)
    else
      redirect_to custom_admin_team_path
    end
  end

  def add_user
    if user  = User.find_by_email(add_user_params[:email])
      user.team_id = add_user_params[:team_id]
      user.last_active_at = Time.now
      if user.account_activation_token.blank?
        user.generate_account_activation_token
        user.account_activated_at = nil
      end
      user.save(validate: false)
      save_provider(user) if !user.student? && user.provider.blank?
      send_notification(user)
      render json: { message: I18n.t('teams.existing_user_success',email: user.email) },status: 200
    else
      process_user
      render json: {message: I18n.t('teams.new_user_success',email: add_user_params[:email])},status: 200
    end
  end

  private

  def process_user
    if user = User.create(add_user_params)
      user.update_attribute(:last_active_at, Time.now)
      save_provider(user)
      send_notification(user)
    end
  end

  def add_user_params
    set_password_params if !params[:password].present? && !params[:password_confirmation].present?
    params.permit(:email,:team_id,:password,:password_confirmation)
  end

  def send_notification(user)
    unless user.private_labeled_user?
      Notification.create(user: user,notification_type: Notification::ADD_TEAM_USER,referenceable:user, sent_via: Notification::EMAIL)
    end
  end

  def set_password_params
    password = SecureRandom.urlsafe_base64(6, false)
    params[:password] = password
    params[:password_confirmation] = password
  end

  def save_provider(user)
      provider = Provider.new
      provider.user = user
      provider.save(validate: false)
    end

end
