class AddNewFieldsToInquiry < ActiveRecord::Migration
  def change
  	add_column :inquiries, :review_of_clinical_guidelines, :text
  	add_column :inquiries, :review_of_meta_analyses, :text
  	add_column :inquiries, :review_of_review_articles, :text
  	add_column :inquiries, :review_of_other_tertiary_literature, :text
  end
end
