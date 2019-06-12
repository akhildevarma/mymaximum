class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name, null: false
      t.integer :a_la_carte_price_in_cents, null: false

      t.timestamps
    end

    add_index :products, :name, unique: true
  end
end
