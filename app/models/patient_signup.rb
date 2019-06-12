class PatientSignup
  include JsonErrorResource
  include GenerallyInvitable
  include ActiveModel::Validations

  validates :accept_terms_of_service, acceptance: true

  json_error_associations :user, :patient, :profile

  def patient
    @patient ||= Patient.new
  end

  def patient=(params)
    @patient = Patient.new(params)
  end

  def profile
    @profile ||= Profile.new
  end

  def profile=(params)
    @profile = Profile.new(params)
  end

  def save
    user.with_transaction_returning_status do
      user.invitation = invitation if invitation.present?

      # user _must_ be saved for later validations to work
      user.save if self.valid?

      patient.user = user
      profile.user = user

      if [self, user, patient, profile].map(&:valid?).all? && user.persisted?
        patient.save!
        profile.save!
        invitation.destroy! if invitation.present?
        queue_welcome_email
        true
      else
        false
      end
    end
  end

  def queue_welcome_email
    SignupMailer.welcome(user).deliver_later(wait: 1.hour)
  end
end
