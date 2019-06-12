class RemoveUnusedColumnsInquiry < ActiveRecord::Migration
  def change
    remove_column :inquiries, :project_type_desc
  end
end
