class CreateInterventions < ActiveRecord::Migration
  def change
    add_column :inquiries, :intervention_response, :boolean, default: false

    create_table :interventions do |t|
      t.belongs_to :submitter, index: true
      t.belongs_to :inquiry, index: true, unique: true
      t.boolean :taken, null: true
      t.text :response

      t.timestamps
    end
  end
end
