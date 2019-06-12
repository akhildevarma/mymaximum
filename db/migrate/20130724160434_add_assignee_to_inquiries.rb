class AddAssigneeToInquiries < ActiveRecord::Migration
  def change
    add_reference :inquiries, :assignee, index: true
  end
end
