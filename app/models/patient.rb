class Patient < ActiveRecord::Base
  belongs_to :user, inverse_of: :patient

  validates :user_id, presence: true
end
