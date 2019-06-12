class Document < ActiveRecord::Base
  extend Enumerize
  has_secure_token

  belongs_to :user
  belongs_to :referenceable, polymorphic: true
  before_create :update_status
  attr_accessor :file_contents

  has_attached_file :file

  validates_attachment :file, presence: true, content_type: { content_type: %w(application/pdf application/msword application/vnd.openxmlformats-officedocument.wordprocessingml.document application/vnd.openxmlformats-officedocument.spreadsheetml.sheet application/vnd.ms-powerpoint application/vnd.openxmlformats-officedocument.presentationml.presentation)}

  enumerize :status,
    in: [:progress, :review, :complete],
    default: :progress,
    scope: true

  def update_status
    self.status = :complete if referenceable_type!='Inquiry'
  end
end
