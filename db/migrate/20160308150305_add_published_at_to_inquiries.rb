class AddPublishedAtToInquiries < ActiveRecord::Migration
  def change
    add_column :inquiries, :published_at, :datetime, :null => true
  end
end
