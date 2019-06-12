class CreateProviders < ActiveRecord::Migration
  def change
    create_table :providers do |t|
      t.references :user, index: true
      t.string :license_number, null: false
      t.boolean :verified, null: false

      t.timestamps
    end
  end
end
