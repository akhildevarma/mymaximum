class CreateDocuments < ActiveRecord::Migration
  def change
    create_table :documents do |t|
      t.integer :user_id
      t.string  :referenceable_type
      t.integer :referenceable_id
      t.timestamps
    end
  end
end
