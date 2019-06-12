class Administrator < ActiveRecord::Base
  extend Enumerize
  enumerize :role,
            in: { user: 1, team_admin: 2, admin: 3},
            default: :admin

  belongs_to :user, inverse_of: :administrator

  validates :user_id, presence: true

  def can?(type:)
    role.to_sym == type
  end
end
