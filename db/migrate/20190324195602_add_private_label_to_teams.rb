class AddPrivateLabelToTeams < ActiveRecord::Migration
  def change
  	add_column :teams, :private_label, :boolean, default: false
  end
end
