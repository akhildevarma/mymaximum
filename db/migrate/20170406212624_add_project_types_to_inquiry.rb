class AddProjectTypesToInquiry < ActiveRecord::Migration
  def change
    add_column :inquiries, :project_types, :string
    add_column :inquiries, :project_type_desc, :string
  end
end
