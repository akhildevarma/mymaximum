class CreatePatients < ActiveRecord::Migration
  def change
    create_table :patients do |t|
      t.references :user, index: true

      t.timestamps
    end
  end
end
