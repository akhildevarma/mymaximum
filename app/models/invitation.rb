class Invitation < ActiveRecord::Base
  STUDENT_INVITATION_TYPE = 'student'
  GENERAL_INVITATION_TYPE = 'general'
  INVITATION_TYPES = [STUDENT_INVITATION_TYPE, GENERAL_INVITATION_TYPE]

  has_one :user
  validates :email, presence: true,  email_format: { message: I18n.t('users.errors.email_format') }
  validates :token, presence: true
  validates :invitation_type, presence: true, inclusion: { in: INVITATION_TYPES }

  before_validation :generate_token, on: :create
  before_validation :downcase_email

  after_create :queue_signup_reminder

  scope :student_invitations, -> { where(invitation_type: STUDENT_INVITATION_TYPE) }
  scope :general_invitations, -> { where(invitation_type: GENERAL_INVITATION_TYPE) }

  INVITATION_TYPES.each do |invitation_type|
    define_method :"#{invitation_type}?" do
      self.invitation_type == invitation_type
    end
  end

  private

  def downcase_email
    self.email = self.email.downcase if self.email.present?
  end

  def generate_token
    self.token = SecureRandom.hex(8) unless self.token.present?
  end

  def queue_signup_reminder
    Delayed::Job.enqueue(InvitationReminderJob.new(self.id),
                         priority: -1,
                         run_at: 7.days.from_now
                        )
  end
end
