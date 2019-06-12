class User::TeamSignup
  include ActiveModel::Model
  include Links

  attr_accessor :user
  attr_accessor :team
  attr_accessor :email_username
  attr_accessor :accept_team_of_service_and_privacy_policy
  attr_accessor :signup_url_path

  validates :email_username, presence: true, format: /\A[\w.+]+\z/
  validates :email_domain, format: /(?:[-a-z0-9]+\.)+[a-z]{2,}/, presence: true

  validates_each :email do |record, attr, value|
    record.errors.add attr, 'Email already taken' if record.email_taken?
  end

  def email_taken?
    User.where(email: self.email).exists?
  end

  def initialize(attributes={})
    self.team = team = Team.where('lower(signup_url_path) = ?', attributes[:signup_url_path]).first
    super
  end

  def user
    @user ||= User.new
  end

  def user=(params)
    @user = User.new(params)
    @user.team_id = team.id
    @user.tap do |user|
      self.email_username = user.email.split('@').first
      self.set_email # Ensure email is not tampered by user
    end
  end

  def update(user,params)
    user.with_transaction_returning_status do
      update_user(user,params)
    end
  end

  def validate_user_params(params, user)
     validate_email_param(params, user)
     validate_password_params(params, user)
     user
  end

  def save
    user.with_transaction_returning_status do
      if self.valid?
        user.account_activated_at = Time.now
        user.account_activation_token = nil
        user.save
        save_provider(user)
      else
        false
      end
    end
  end

  ## Attribute methods
  def email_domain
    return nil if team.blank?
    "#{team.email_domain}"
  end

  def email
    if email_username && email_domain
      user.email = "#{email_username}@#{email_domain}"
      user.email
    else
      nil
    end
  end
  alias_method :set_email, :email

  def email?;!!email;end

  # def valid_attribute?(attribute_name)
    # self.valid?
    # self.errors[attribute_name].blank?
  # end

  def update_user(user,params)
    if params[:user][:email]!=user.email
      user.email = params[:user][:email]
    end
    user.account_activated_at = Time.now
    user.account_activation_token = nil
    user.password = params[:user][:password]
    user.password_confirmation = params[:user][:password_confirmation]
    user.save
  end

  private
    
    def validate_password_params(params, user)
      user.errors[:password] << I18n.t('signup.team_provider.password') if params[:password].blank?
      user.errors[:password] << I18n.t('signup.team_provider.password_length') if params[:password].size < 6
      user.errors[:password_confirmation] << I18n.t('signup.team_provider.password_confirmation') if params[:password]!=params[:password_confirmation]
    end

    def validate_email_param(params, user)
      if ValidatesEmailFormatOf::validate_email_format(params[:email]).present?
        user.errors[:email] << I18n.t('signup.team_provider.invalid')
      elsif (user.email!=params[:email] && User.where(email: params[:email]).exists?)
        user.errors[:email] << I18n.t('signup.team_provider.email_taken')
      end
    end

    def save_provider(user)
      provider = Provider.new
      provider.user = user
      provider.skip_specialty_validation = true
      provider.save(validate: false)
    end
end
