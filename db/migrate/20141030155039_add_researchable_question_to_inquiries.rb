class AddResearchableQuestionToInquiries < ActiveRecord::Migration
  def change
    add_column :inquiries, :researchable_question, :text
  end
end
