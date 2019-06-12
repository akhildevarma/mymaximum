class AddActiveToStudent < ActiveRecord::Migration
  def change
    add_column :students, :is_active, :boolean
  end
end
