class AddMoreResponseSectionsToInquiries < ActiveRecord::Migration
  def change
    add_column :inquiries, :background, :text
    add_column :inquiries, :relevant_prescribing_info, :text
  end
end
