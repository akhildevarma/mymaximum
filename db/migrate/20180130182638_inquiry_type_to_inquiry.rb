class InquiryTypeToInquiry < ActiveRecord::Migration
  def change
    add_column :inquiries, :inquiry_type, :string, default: 'non_blog'
  end
end
