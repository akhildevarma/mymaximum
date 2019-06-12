class CreateSignupTrackers < ActiveRecord::Migration
  def change
    create_table :signup_trackers do |t|
      t.string :email
      t.string :status
      t.integer :notified_count

      t.timestamps null: false
    end
  end
end
