class RemoveIndexFromProviders < ActiveRecord::Migration
  def change
    remove_index :providers, name: 'index_providers_on_license_number_and_licensing_state'
  end
end
