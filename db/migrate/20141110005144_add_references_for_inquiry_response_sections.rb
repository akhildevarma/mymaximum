class AddReferencesForInquiryResponseSections < ActiveRecord::Migration
  def change
    add_column :inquiries, :background_references, :text
    add_column :inquiries, :relevant_prescribing_info_references, :text
  end
end
