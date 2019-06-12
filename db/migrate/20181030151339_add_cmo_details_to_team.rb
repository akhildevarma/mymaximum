class AddCmoDetailsToTeam < ActiveRecord::Migration
  def change
  	add_column :teams, :cmo_email, :string #cmo-chief medical officer
  	add_column :teams, :cmo_name, :string
  	add_column :teams, :cmo_phone, :string
  end
end
