class AddCompletedAtToInquiry < ActiveRecord::Migration
  def change
    add_column :inquiries, :completed_at, :datetime
  end
end
