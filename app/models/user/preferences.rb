class User::Preferences < ActiveRecord::Base
  DEFAULT = {
    inquiry_view_default_combined: true
  }
  belongs_to :user

  def self.default
    new(DEFAULT)
  end

end
