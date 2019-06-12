class AddKindAndHiddenToTeams < ActiveRecord::Migration
  def change
    add_column :teams, :hidden, :boolean, :default => true
    add_column :teams, :kind, :string, :null => true
  end
end
