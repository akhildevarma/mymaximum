class AddTitleToInquiry < ActiveRecord::Migration
  def change
    add_column :inquiries, :title, :text
    add_column :inquiries, :slug, :text

    add_index :inquiries, :slug
    add_index :guids, [:uid]
  end
end
