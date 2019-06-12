class SignupTracker < ActiveRecord::Base
  extend Enumerize
  enumerize :status,
           in: [:complete, :incomplete],
      default: :incomplete

  def self.singup_tracker_reminder
    all.each do |signup_user|
      SignupTrackerMailer.signup_reminder(signup_user).deliver_now
    end
  end
end
