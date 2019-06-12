class Profile < ActiveRecord::Base
  belongs_to :user, inverse_of: :profile

  validates :user_id, presence: true

  # validates :first_name
  # validates :last_name
  validates :phone_number, allow_blank: true, length: 10..15, uniqueness: true

  def phone_number=(number)
    self[:phone_number] = number && number.gsub(/\D/, '')
  end
end
