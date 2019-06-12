class CreateUserEmails < ActiveRecord::Migration
  def change
    create_table :user_emails do |t|
      t.string :email
      t.belongs_to :user
    end
  end
end
