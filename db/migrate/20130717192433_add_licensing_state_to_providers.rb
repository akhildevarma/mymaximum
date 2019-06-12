class AddLicensingStateToProviders < ActiveRecord::Migration
  def change
    add_column :providers, :licensing_state, :string
  end
end
