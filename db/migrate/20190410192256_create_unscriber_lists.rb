class CreateUnscriberLists < ActiveRecord::Migration
  def change
    create_table :unscriber_lists do |t|
      t.string :email
      t.integer :group_id

      t.timestamps null: false
    end
  end
end
