class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string :title
      t.integer :user_id
      t.text :body
      t.boolean :deleted
      t.string  :referenceable_type
      t.integer :referenceable_id
      t.timestamps
    end
  end
end
