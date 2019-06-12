class Guid < ActiveRecord::Base
  before_create :generate_uid
  belongs_to :referenceable, polymorphic: true

  

  def generate_uid
    begin
      self.uid = SecureRandom.uuid
    end while self.class.exists?(uid: uid)
  end
end
