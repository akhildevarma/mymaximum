class CreateStudySummaries < ActiveRecord::Migration
  def change
    create_table :study_summaries do |t|
      t.references :inquiry, index: true
      t.references :responder, index: true
      t.text :body
      t.text :notes
      t.boolean :complete, default: false

      t.timestamps
    end
  end
end
