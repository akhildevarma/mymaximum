class RemoveUniqueIndexOnProviderLicenseNumbers < ActiveRecord::Migration
  def up
    remove_index :providers, ['license_number']
  end

  def down
    add_index :providers, ['license_number'], unique: true
  end
end
