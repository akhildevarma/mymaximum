class AddHideSectionsToInquiry < ActiveRecord::Migration
  def change
     add_column :inquiries, :hidden_sections, :json
  end
end
