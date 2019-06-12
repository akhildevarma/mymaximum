class CreateHospitalDrugs < ActiveRecord::Migration
  def change
    create_table :hospital_drugs do |t|
      t.string :title
      t.integer  "team_id"
      t.timestamps
    end
  end
end
