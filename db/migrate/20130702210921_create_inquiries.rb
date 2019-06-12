class CreateInquiries < ActiveRecord::Migration
  def change
    create_table :inquiries do |t|
      t.text :question
      t.string :status
      t.integer :turnaround_time
      t.references :submitter, index: true

      t.timestamps
    end
  end
end
