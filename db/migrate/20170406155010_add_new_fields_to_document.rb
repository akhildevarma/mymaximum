class AddNewFieldsToDocument < ActiveRecord::Migration
  def change
    add_column :documents, :status, :string
    add_column :documents, :description, :text
  end
end
