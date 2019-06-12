class StudentSignup
  include ActiveModel::Model
  include ActiveModel::Validations

  validate :has_student_invitation
  validates :accept_terms_of_service, acceptance: true

  def invitation
    @invitation ||= Invitation.new
  end

  def invitation=(params)
    @invitation = Invitation.where(params).first || Invitation.new(params)
  end

  def token=(token)
    self.invitation = { token: token }
  end

  def user
    @user ||= User.new
  end

  def user=(params)
    @user = User.new(params)
  end

  def email=(address)
    self.user.email = address
  end

  def student
    @student || Student.new
  end

  def save
    user.with_transaction_returning_status do
      user.invitation = invitation
      user.save if self.valid?

      @student = Student.new(user: user)
      if [self, user, student].map(&:valid?).all? && user.persisted?
        student.save!
        invitation.destroy!
        true
      else
        false
      end
    end
  end

  private 

  def has_student_invitation
    if invitation.new_record? || !invitation.student?
      error = I18n.t('signup.student.invalid_invitation_token')
      errors[:invitation_token] << error
      @invitation.errors[:token] << error
    end
  end
end
