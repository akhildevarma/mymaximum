class AddUniqueIndexOnLicenseNumberAndStateToProviders < ActiveRecord::Migration
  def change
    add_index :providers, [:license_number, :licensing_state], unique: true
  end
end
