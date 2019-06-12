class AddDoNotTextToUser < ActiveRecord::Migration
  def change
    add_column :users, :do_not_text, :boolean
  end
end
