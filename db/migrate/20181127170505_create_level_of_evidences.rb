class CreateLevelOfEvidences < ActiveRecord::Migration
  def change
    create_table :level_of_evidences do |t|
      t.string :level
      t.string :treatment
      t.string :medicine

      t.timestamps null: false
    end
  end
end
