class CreateVersions < ActiveRecord::Migration
  def change
    create_table :versions do |t|
      t.string   :item_type, :null => false
      t.integer  :item_id,   :null => false
      t.string   :event,     :null => false
      t.string   :whodunnit
      t.text     :object
      t.integer  :inquiry_assignee_id
      t.string   :inquiry_status
      t.datetime :created_at
    end
    add_index :versions, [:item_type, :item_id]
    add_index :versions, [:inquiry_assignee_id]
    add_index :versions, [:inquiry_status]
  end
end
