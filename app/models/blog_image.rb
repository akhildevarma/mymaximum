class BlogImage < ActiveRecord::Base
  belongs_to :user
  belongs_to :referenceable, polymorphic: true

   # Paperclip Image Attachment
  has_attached_file :image, styles: {
    thumb: '50x50>',
    small: '200x200>',
    medium: '500x500>'
  }

  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/


end
