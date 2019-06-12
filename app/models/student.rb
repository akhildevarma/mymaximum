class Student < ActiveRecord::Base
  include Notifiable

  PRIORITY_DCS = ['campbell.edu', 'isu.edu', 'une.edu', 'uri.edu']

  belongs_to :user, inverse_of: :student

  before_create :set_last_auto_assign

  validates :user_id, presence: true

  scope :assignable, -> { where(can_assign: true) }
  scope :not_alumni, -> { where(is_alumn: false) }
  scope :active, -> { where(is_active: true) }
  scope :priority, -> { where(is_priority: true) }

  # This for https://github.com/InpharmD/inpharmd/issues/1217
  scope :front_runners, -> { assignable.active.priority }
  

  attr_accessor :assigned_inquiry

  def self.next_assignee
    potential_assignees = front_runners
    potential_assignees = assignable.active if potential_assignees.empty?
    potential_assignees = assignable.not_alumni if potential_assignees.empty?
    potential_assignees.order(:last_auto_assign).first
  end

  def assign!(inquiry)
    self.assigned_inquiry = inquiry
    update(last_auto_assign: DateTime.now)
    notify!(:assigned)
  end

  def notify_assigned
    InquirySubmissionMailer.assignment_notification(assigned_inquiry).deliver_later
    send_sms_notification('You\'ve been assigned a new InpharmD inquiry. If this is in error, reply "error", and we\'ll reassign', to: user)
  end

  private

  def set_last_auto_assign
    self.last_auto_assign = DateTime.now
  end
end
