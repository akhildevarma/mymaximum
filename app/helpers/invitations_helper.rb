module InvitationsHelper
  def invitation_types
    Invitation::INVITATION_TYPES.map { |t| [t.capitalize, t] }
  end
end
