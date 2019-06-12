class AddViewEveryoneToInquiry < ActiveRecord::Migration
  def change
    add_column :inquiries, :view_everyone, :boolean, default: false
  end
end
