class CreatePlans < ActiveRecord::Migration
  def change
    create_table :plans do |t|
      t.string :name, null: false
      t.integer :price_in_cents, null: false
      t.string :interval, null: false
      t.string :description, null: false

      t.timestamps
    end

    add_index :plans, :name, unique: true
  end
end
