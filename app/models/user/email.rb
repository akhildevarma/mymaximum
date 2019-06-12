class User::Email < ActiveRecord::Base
  before_create :generate_access_token
  belongs_to :user
  after_create :notify_account_update

  validates :email, uniqueness: true, presence: true, email_format: { message: I18n.t('users.errors.email_format') }

  def activate_email!
    if activation_token.present?
      update_attribute(:activated_at, Time.now.utc) 
      update_attribute(:activation_token, nil)
    end
  end

  def email_activated?
    !!activated_at
  end

  private
  
    def generate_access_token
      begin
        self.activation_token = SecureRandom.hex
      end while self.class.exists?(activation_token: activation_token)
    end

    def notify_account_update
      self.activate_email!
      UserMailer.account_updated(self).deliver_now
    end
end
