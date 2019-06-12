class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.integer :user_id
      t.string  :referenceable_type
      t.integer :referenceable_id
      t.string  :notification_type #type is reserved for storing the class in case of inheritance
      t.string  :sent_via
      t.text    :message
      t.timestamps
    end

     add_index "notifications", ["user_id"], name: "index_notifications_on_user_id", using: :btree
     add_index "notifications", ["referenceable_type"], name: "index_notifications_on_referenceable_type", using: :btree
  end
end
