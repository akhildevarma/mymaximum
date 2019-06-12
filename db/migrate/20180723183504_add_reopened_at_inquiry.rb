class AddReopenedAtInquiry < ActiveRecord::Migration
  def change
    add_column :inquiries, :reopened_at, :datetime, :null => true
  end
end
