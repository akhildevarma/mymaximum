class AddLaunchDateToTeam < ActiveRecord::Migration
  def change
    add_column :teams, :launch_date, :date
  end
end
