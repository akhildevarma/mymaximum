class AddCustomResponseTextToInquiries < ActiveRecord::Migration
  def change
    add_column :inquiries, :custom_response_text, :text
  end
end
