class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.references :payment_account
      t.string :name
      t.boolean :active, null: false, default: true
    end

    add_reference :users, :team, index: true

    add_index :teams, :name, unique: true
  end
end
