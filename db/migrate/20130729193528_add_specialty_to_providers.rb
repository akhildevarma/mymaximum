class AddSpecialtyToProviders < ActiveRecord::Migration
  def change
    add_column :providers, :specialty, :string
  end
end
