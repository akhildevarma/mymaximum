class AddDocUrlToInquiry < ActiveRecord::Migration
  def change
    add_column :inquiries, :doc_url, :string
  end
end
