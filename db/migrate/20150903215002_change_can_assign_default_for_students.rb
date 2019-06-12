class ChangeCanAssignDefaultForStudents < ActiveRecord::Migration
  def up
    change_column :students, :can_assign, :boolean, :default => false
  end

  def down
    change_column :students, :can_assign, :boolean, :default => true
  end
end
