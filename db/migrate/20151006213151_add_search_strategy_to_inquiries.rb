class AddSearchStrategyToInquiries < ActiveRecord::Migration
  def change
    add_column :inquiries, :search_strategy, :text
  end
end
