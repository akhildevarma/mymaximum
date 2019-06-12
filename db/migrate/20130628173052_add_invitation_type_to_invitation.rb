class AddInvitationTypeToInvitation < ActiveRecord::Migration
  def change
    add_column :invitations, :invitation_type, :string
  end
end
