class RemoveProviderTableConstraints < ActiveRecord::Migration
  def change
    change_column_null(:providers, :license_number, true)
    change_column_null(:providers, :verified, true)
  end
end
