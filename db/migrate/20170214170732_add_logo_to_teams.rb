class AddLogoToTeams < ActiveRecord::Migration
  def self.up
    add_attachment :teams, :logo
  end

  def self.down
    remove_attachment :teams, :logo
  end
end
