class SetDefaultVerifiedOnProviders < ActiveRecord::Migration
  def change
    change_column_default :providers, :verified, :false
  end
end
