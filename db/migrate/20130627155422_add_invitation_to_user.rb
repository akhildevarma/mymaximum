class AddInvitationToUser < ActiveRecord::Migration
  def change
    add_reference :users, :invitation, index: true
  end
end
