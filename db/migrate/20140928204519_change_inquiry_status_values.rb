class ChangeInquiryStatusValues < ActiveRecord::Migration
  def up
    Inquiry.where(status: :literature_search).each do |inquiry|
      inquiry.update_attribute(:status, Inquiry.statuses[0])
    end
  end

  def down
    Inquiry.where(status: :research).each do |inquiry|
      inquiry.update_attribute(:status, Inquiry.statuses[0])
    end
  end
end
