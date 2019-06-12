class AddFrontRunnersToStudent < ActiveRecord::Migration
  def change
    add_column :students, :is_priority, :boolean, default: false
  end
end
