class AddRoundRobinToStudents < ActiveRecord::Migration
  def change
    add_column :students, :can_assign, :boolean, default: true
    add_column :students, :last_auto_assign, :datetime, null: true
  end
end
