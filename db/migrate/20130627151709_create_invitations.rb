class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.string :token, null: false
      t.string :email, null: false
      t.belongs_to :user
      t.timestamps
    end
  end
end
