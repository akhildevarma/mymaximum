class AlterUid < ActiveRecord::Migration
  def change
    change_column :guids, :uid, :string, null: false
    add_index :guids, [:referenceable_id]
  end
end
