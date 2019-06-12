class CreateApplicationSettings < ActiveRecord::Migration
  def change
    create_table :application_settings do |t|
      t.boolean :require_general_invitations, null: false

      t.timestamps
    end
  end
end
