class WaitlistedUser < ActiveRecord::Base
  validates :email, presence: true, uniqueness: true, email_format: { message: I18n.t('users.errors.email_format') }
  validates :provider, inclusion: { in: [true, false] }

  scope :providers, -> { where(provider: true) }
  scope :patients, -> { where(provider: false) }
  scope :next, ->(number) { order('created_at ASC').limit(number) }

  def self.for_provider(attributes = {})
    new(attributes.merge(provider: true))
  end

  def self.for_patient(attributes = {})
    new(attributes.merge(provider: false))
  end
end
