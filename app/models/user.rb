class User < ActiveRecord::Base
  has_secure_password

  has_one :administrator, inverse_of: :user
  has_one :student, inverse_of: :user, dependent: :destroy
  has_one :provider, inverse_of: :user, dependent: :destroy
  has_one :patient, inverse_of: :user, dependent: :destroy

  has_one :profile, inverse_of: :user, dependent: :destroy
  has_one :payment_account, inverse_of: :user, dependent: :destroy
  belongs_to :team

  has_many :comments
  has_many :api_keys, class_name: 'APIKey'
  has_many :documents,->{ where('file_file_name is not NULL and referenceable_type = ?', 'User').order(created_at: :desc)}, class_name: 'Document',foreign_key: 'referenceable_id'

  belongs_to :invitation, dependent: :destroy

  has_many :survey_responses, inverse_of: :responder, foreign_key: :responder_id, dependent: :destroy

  has_many :submitted_inquiries, ->{ where('inquiry_type = ?', 'non_blog')},  class_name: 'Inquiry', foreign_key: :submitter_id, inverse_of: :submitter, dependent: :destroy
  has_many :assigned_inquiries, class_name: 'Inquiry', foreign_key: :assignee_id, inverse_of: :assignee
  has_many :interventions, through: :submitted_inquiries, foreign_key: :submitted_id

  has_many :topic_searches, inverse_of: :submitter, foreign_key: :submitter_id, dependent: :destroy

  has_many :emails, -> { where('activated_at is not null and activation_token is null') },  class_name: 'User::Email'
  has_one :preferences

  validates :password, presence: { on: :create }, length: { minimum: 6, allow_nil: true }
  validates :password_confirmation, presence: true, if: :password_digest_changed?
  validates :email, uniqueness: true, presence: true, email_format: { message: I18n.t('users.errors.email_format') }

  before_validation :downcase_email!
  before_create :generate_account_activation_token

  scope :active_today,
        -> {
          where(last_active_at: Time.now.beginning_of_day..Time.now.end_of_day)
        }

  scope :active_last_30,
        -> { where('last_active_at >= :last_30', last_30: DateTime.now - 30.days) }

  scope :active_last_week,
        -> { where('last_active_at >= :last_7', last_7: DateTime.now - 7.days) }

  scope :registered_last_week,
        -> { where('created_at >= :last_7', last_7: DateTime.now - 7.days) }

  scope :registered_a_month_ago, 
        -> { where("created_at <= ?", 1.month.ago) }

  scope :new_by_month,
    -> { all.order('created_at ASC').group_by { |t| t.created_at.beginning_of_month.strftime("%b %y") }.map { |month, collection| [month,collection.count] } }

  scope :last_active_by_month,
    -> { active.order('last_active_at ASC').group_by { |t| t.last_active_at.beginning_of_month.strftime("%b %y") }.map { |month, collection| [month,collection.count] } }

  scope :by_inquiries_count, -> {
          find_by_sql("""
            SELECT u.email, COUNT(i.id) AS inquiries_count
            FROM inquiries i, users u
            WHERE i.submitter_id = u.id
            GROUP BY u.email
            ORDER BY inquiries_count DESC
          """)
        }

  scope :not_in_team, -> {
    where('team_id IS NULL')
  }
  scope :in_team, -> {
    where('team_id IS NOT NULL')
  }
  scope :active, -> {
    where('last_active_at IS NOT NULL')
  }
  scope :inactive, -> {
    where('last_active_at IS NULL')
  }
  scope :invited, -> {
    where('invitation_id IS NOT NULL')
  }

  scope :activated_user, ->(email) {
    where('email = ? and account_activated_at is not null', email.downcase)
  }

  def self.to_csv(kwargs={})
    kwargs = kwargs || {}
    attributes = kwargs[:attributes] || column_names
    profile_attributes = kwargs[:profile_attributes] || []
    team_attributes = kwargs[:team_attributes] || []
    options = kwargs[:options] || {}

    CSV.generate(options) do |csv|
      csv.add_row attributes \
        + (profile_attributes.map {|a| "profile.#{a}"}) \
        + (team_attributes.map {|a| "team.#{a}"})

      all.each do |user|

        values = user.attributes.slice(*attributes).values

        if user.profile
          values += user.profile.attributes.slice(*profile_attributes).values
        end

        if user.team
          values += user.team.attributes.slice(*team_attributes).values
        end

        csv.add_row values
      end
    end
  end

  def self.for_authentication(options)
    set_deprecation_warning = !!options.delete(:set_deprecation_warning)
    user_email = User::Email.find_by(options) rescue nil
    deprecation_warning = !!user_email.try(:is_deprecated)
    user = if (user_email && user_email.activation_token.nil?)
      user_email.user
    else
      find_by(options)
    end
    set_deprecation_warning ? [user, deprecation_warning] : user
  end

  def self.authenticate(email, password)
    user = for_authentication(email: email)
    return nil unless user
    
    if (user.last_active_at && user.last_active_at <= 2.months.ago)
        UserMailer.inactive_users(user).deliver_now
    end

    user.active!
    user.authenticate(password)
  end

  def can_update?(resource)
    resource && resource.can_be_updated_by?(self)
  end

  def administrator?
    self.administrator.present? && self.administrator.can?(type: :admin)
  end

  def team_admin?
    self.administrator.present? && self.administrator.can?(type: :team_admin)
  end

  def student?
    self.student.present?
  end

  def document_user?
    administrator? || team_admin? || student?
  end

  def priority_student!
    if self.student? && Student::PRIORITY_DCS.include?(self.email.downcase.split('@').last)
      self.student.update_attribute(:is_priority, true)
    end
  end

  def provider?
    self.provider.present?
  end

  def patient?
    self.patient.present?
  end

  def always_exempt_from_billing
    self.administrator? || self.student? || self.in_team?
  end

  def should_be_billed_for_inquiries?
    !( self.always_exempt_from_billing || self.trialing? )
  end

  def trialing?
    !!self.payment_account.try(:trialing?)
  end

  def initial_survey_response
    survey_responses.where(initial: true, rating: nil).first
  end

  def followup_survey_response
    survey_responses.where(initial: false, rating: nil).first
  end

  def open_survey_response
    return initial_survey_response if initial_survey_response && initial_survey_response.incomplete?
    return followup_survey_response if followup_survey_response && followup_survey_response.incomplete?
    nil
  end

  def not_activated_email
    User::Email.where(user: self, activated_at: nil).last
  end

  def generate_password_reset!
    self.password_reset_token = SecureRandom.urlsafe_base64
    self.password_reset_sent_at = Time.zone.now
    save!
  end

  def password_reset_token_too_old?
    self.password_reset_sent_at < 2.hours.ago
  end

  def password_digest=(digest)
    self[:password_digest] = digest
    self.password_reset_token = nil
  end

  def full_name_or_email
    profile.present? &&  profile.first_name.present? ? profile.decorate.full_name : self.email
  end

  def type
    types = []
    types << 'student' if student?
    types << 'provider' if provider?
    types << 'patient' if patient?
    types.join(', ')
  end

  def active!
    update_attribute(:last_active_at, Time.now.utc)
  end

  def requires_account_activation?
    !!account_activation_token && !account_activated?
  end

  def account_activated?
    !!account_activated_at
  end

  def generate_account_activation_token
    self.account_activation_token = loop do
      random_token = SecureRandom.urlsafe_base64(10, false)
      break random_token unless self.class.exists?(account_activation_token: random_token)
    end
  end

  def activate_account!
    update_attribute(:account_activated_at, Time.now.utc) unless account_activated_at.present?
    update_attribute(:account_activation_token, nil)
    return true
  end

  def in_team?
    !!team
  end

  def private_labeled_user?
    in_team? && team.private_label?
  end

  def self.personal_email
    registered_a_month_ago.each do |user|
      UserMailer.personal_email(user).deliver_now
    end
  end

  def self.search(search)
    User.joins(:profile).where('profiles.first_name ILIKE :search OR profiles.last_name ILIKE :search OR profiles.phone_number ILIKE :search OR users.email ILIKE :search', search: "%#{search}%")
  end

  private

  def downcase_email!
    self.email.downcase! if self.email.present?
  end
end
