class CreateGuids < ActiveRecord::Migration
  def change
    create_table :guids do |t|
      t.integer :uid
      t.string  :referenceable_type
      t.integer :referenceable_id
      t.timestamps
    end
  end
end
