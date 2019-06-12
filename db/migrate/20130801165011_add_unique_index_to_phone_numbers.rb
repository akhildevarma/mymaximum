class AddUniqueIndexToPhoneNumbers < ActiveRecord::Migration
  def change
    add_index :profiles, :phone_number, unique: true
  end
end
