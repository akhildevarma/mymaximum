class AddLevelOfEvidenceToInquiry < ActiveRecord::Migration
  def change
  	add_column :inquiries, :level_of_evidence, :text
  end
end
