class AddReadAtToInquiries < ActiveRecord::Migration
  def change
  	add_column :inquiries, :read_at, :datetime, :null => true
  end
end
