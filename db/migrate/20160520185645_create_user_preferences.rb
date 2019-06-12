class CreateUserPreferences < ActiveRecord::Migration
  def change
    create_table :user_preferences do |t|
      t.references :user, index: true
      t.boolean :inquiry_view_default_combined
    end
  end
end
