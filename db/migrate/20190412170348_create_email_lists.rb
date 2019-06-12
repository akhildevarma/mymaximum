class CreateEmailLists < ActiveRecord::Migration
  def change
    create_table :email_lists do |t|
      t.string :Group

      t.timestamps null: false
    end
  end
end
