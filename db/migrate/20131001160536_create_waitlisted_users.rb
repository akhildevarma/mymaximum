class CreateWaitlistedUsers < ActiveRecord::Migration
  def change
    create_table :waitlisted_users do |t|
      t.string :email, null: false
      t.boolean :provider, null: false

      t.timestamps
    end

    add_index :waitlisted_users, :email, unique: true
  end
end
