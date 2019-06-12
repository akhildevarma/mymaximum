class AddAlumniToStudent < ActiveRecord::Migration
  def change
    add_column :students, :is_alumn, :boolean, default: false

    add_index :students, :is_alumn
  end
end
