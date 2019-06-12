class AddIndexesToStudent < ActiveRecord::Migration
  def change
    add_index :students, :can_assign
    add_index :students, :last_auto_assign
  end
end
