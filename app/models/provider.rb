class Provider < ActiveRecord::Base
  attr_accessor :skip_specialty_validation

  belongs_to :user, inverse_of: :provider

  validates :user_id, presence: true
  validates :license_number, presence: true, uniqueness: { scope: :licensing_state }, unless: Proc.new { |p| p.user.team_id.present? }
  validates :licensing_state, presence: true, unless: Proc.new { |p| p.user.in_team? }
  # validates :specialty, presence: true, unless: :skip_specialty_validation

  before_update :reset_verified, if: :license_number_changed?
  before_update :reset_verified, if: :licensing_state_changed?

  # Users who are Team, Student and Admin, at time of sending, will not receive this email.
  # Other users, who signup on their own, will receive this email.
  after_create :queue_payment_reminder, unless: Proc.new { |p| p.user.always_exempt_from_billing }

  private

  def reset_verified
    self.verified = false

    true
  end

  def queue_payment_reminder
    Delayed::Job.enqueue(
      PaymentReminderJob.new(self.id),
      priority: -1,
      run_at: 90.days.from_now
    )
  end
end
