class RemoveIndexOnProfile < ActiveRecord::Migration
  def change
    remove_index :profiles, name: 'index_profiles_on_phone_number'
    add_index "profiles", ["phone_number"], name: "index_profiles_on_phone_number", using: :btree
  end
end
