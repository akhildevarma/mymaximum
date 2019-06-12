class AddRoleToAdminstrator < ActiveRecord::Migration
  def change
    add_column :administrators, :role, :integer, :default => 3
  end
end
