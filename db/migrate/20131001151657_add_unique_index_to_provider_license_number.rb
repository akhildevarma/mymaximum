class AddUniqueIndexToProviderLicenseNumber < ActiveRecord::Migration
  def change
    add_index :providers, :license_number, unique: true
  end
end
