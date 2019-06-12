class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.string :first_name
      t.string :middle_name
      t.string :last_name
      t.string :name_suffix
      t.string :name_title
      t.string :company
      t.string :city
      t.string :state
      t.string :phone_number
      t.string :contact_preference
      t.references :user, index: true

      t.timestamps
    end
  end
end
