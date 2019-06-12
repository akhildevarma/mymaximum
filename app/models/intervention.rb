class Intervention < ActiveRecord::Base
  belongs_to :inquiry
  belongs_to :submitter, class_name: 'User'
end
