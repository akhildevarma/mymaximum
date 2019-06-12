class ApplicationSettings < ActiveRecord::Base
  validates :require_general_invitations, inclusion: { in: [true, false] }
  validates :allow_promo_code, inclusion: { in: [true, false] }

  def self.load
    self.last || create(require_general_invitations: true, allow_promo_code: false)
  end
end
