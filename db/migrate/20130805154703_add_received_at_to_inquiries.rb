class AddReceivedAtToInquiries < ActiveRecord::Migration
  def change
    add_column :inquiries, :received_at, :datetime
  end
end
