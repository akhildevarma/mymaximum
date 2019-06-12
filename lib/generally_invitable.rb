module GenerallyInvitable
  extend ActiveSupport::Concern  
  include ActiveModel::Model
  include ActiveModel::Validations
 
  included do
    validate :has_general_invitation, if: -> { ApplicationSettings.load.require_general_invitations }
  end

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

  private

  def has_general_invitation
    if invitation.new_record? || !invitation.general?
      error = I18n.t('signup.invalid_invitation_token')
      errors[:invitation_token] << error
      @invitation.errors[:token] << error
    end
  end

  def invitation_matches_email
    if invitation.persisted? && invitation.email != user.email
      error = I18n.t('users.errors.invitation_matches_email')
      errors[:email] << error
      @user.errors[:email] << error
    end
  end
end
