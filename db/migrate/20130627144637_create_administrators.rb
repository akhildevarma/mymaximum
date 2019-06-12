class CreateAdministrators < ActiveRecord::Migration
  def change
    create_table :administrators do |t|
      t.belongs_to :user, null: false

      t.timestamps
    end
  end
end
