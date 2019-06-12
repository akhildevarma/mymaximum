class ProviderSignup
  include JsonErrorResource
  include ActiveModel::Validations
  include GenerallyInvitable
  include ActiveModel::Serialization

  validates :accept_terms_of_service, acceptance: true

  json_error_associations :user, :provider, :profile, :payment_account

  def id
    SecureRandom.hex
  end
  
  def provider
    @provider ||= Provider.new
  end

  def provider=(params)
    @provider = Provider.new(params)
  end

  def profile
    @profile ||= Profile.new
  end

  def profile=(params)
    @profile = Profile.new(params)
  end

  def payment_account
    @payment_account ||= PaymentAccount.new
  end

  def payment_account=(params)
    @payment_account = PaymentAccount.new(params)
  end

  def save
    user.with_transaction_returning_status do
      user.invitation = invitation if invitation.present?
      # user _must_ be saved for later validations to work
      user.save if self
      provider.skip_specialty_validation = true
      provider.user = user
      profile.user = user
      payment_account.user = user
      payment_account.plan_id = Plan.provider_per_request.id if payment_account.plan_id.nil?

      # pull out all the errors at once
      if [self, user, provider, profile, payment_account].map(&:valid?).all? && user.persisted?
        provider.save!
        profile.save!
        invitation.destroy! if invitation.present?
        payment_account.save_with_payment!
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
